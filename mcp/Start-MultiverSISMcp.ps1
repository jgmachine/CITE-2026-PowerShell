<#
.SYNOPSIS
Lets an AI assistant use MultiverSIS commands as tools, over the Model Context Protocol (MCP).

.DESCRIPTION
VS Code (GitHub Copilot), Claude, and other AI apps start this script and talk to it through
stdin and stdout. The AI never reads this code. It only sees the tool list, and everything on
that list comes from the commands you met in Act 1:

    Get-Command  ->  tool names, parameters, types, required parameters, [ValidateSet()] choices
    Get-Help     ->  what each tool and each parameter is for (your comment-based help)
    The verb     ->  Get-* is marked read-only, Remove-* is marked destructive

Only the commands in -Command are exposed. Start read-only and add write commands on purpose.

.PARAMETER Command
The allowlist: the only commands the AI can call.

.PARAMETER ListTools
Shows the tool list the AI would receive, then exits.

.EXAMPLE
./mcp/Start-MultiverSISMcp.ps1 -ListTools | Select-Object name, description

.NOTES
The API key comes from $env:MULTIVERSIS_API_KEY (VS Code prompts for it; see .vscode/mcp.json),
or from Get-Secret MultiverSIS if that's empty. Logs go to stderr, never stdout.
#>
[CmdletBinding()]
param(
    [string[]] $Command = @('Get-SISStudent', 'Get-SISSchool'),

    [switch] $ListTools
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$protocolVersions = @('2026-07-28', '2025-11-25', '2025-06-18', '2025-03-26')
$serverInfo = [ordered]@{ name = 'multiversis'; version = '1.0.0' }
$instructions = 'Tools for MultiverSIS, a pretend student information system full of made-up students. ' +
    'Call Get-SISSchool first to get exact school names before filtering students by school.'

$repoModules = (Resolve-Path (Join-Path $PSScriptRoot '../modules')).Path
$env:PSModulePath = $repoModules + [IO.Path]::PathSeparator + $env:PSModulePath
Import-Module MultiverSIS

function Write-McpLog([string] $Message) {
    [Console]::Error.WriteLine("[multiversis-mcp] $Message")
}

# ---------------------------------------------------------------------------------------------
# 1. Describe each allowed command as a tool. This is Get-Command and Get-Help, for robots.
# ---------------------------------------------------------------------------------------------
$readOnlyVerbs    = 'Get', 'Find', 'Search', 'Test', 'Measure', 'Show', 'Read', 'Resolve', 'Compare'
$destructiveVerbs = 'Remove', 'Clear', 'Reset', 'Disable', 'Stop', 'Uninstall', 'Unregister', 'Revoke'
$notForTheAI      = @([System.Management.Automation.PSCmdlet]::CommonParameters) + 'Confirm', 'UseTransaction'

function ConvertTo-JsonSchemaType([type] $Type) {
    if ($Type -in [switch], [bool])                    { return 'boolean' }
    if ($Type -in [int], [long], [int16], [byte])      { return 'integer' }
    if ($Type -in [double], [single], [decimal])       { return 'number' }
    return 'string'
}

function ConvertTo-McpTool([System.Management.Automation.CommandInfo] $Info) {
    $help = Get-Help $Info.Name -Full

    # The tool's description is the help: synopsis, description, and examples.
    $text = [System.Collections.Generic.List[string]]::new()
    $text.Add($help.Synopsis.Trim())
    $details = ($help.description.Text -join "`n").Trim()
    if ($details) { $text.Add($details) }
    foreach ($example in $help.examples.example) {
        $remarks = ($example.remarks.Text -join ' ').Trim()
        $text.Add("Example: $($example.code.Trim())$(if ($remarks) { " ($remarks)" })")
    }

    $properties = [ordered]@{}
    $required = [System.Collections.Generic.List[string]]::new()
    foreach ($parameter in $Info.Parameters.Values) {
        if ($parameter.Name -in $notForTheAI) { continue }
        if ($parameter.ParameterType -eq [securestring]) { continue }   # never hand secrets to the AI

        $type = $parameter.ParameterType
        $schema = if ($type.IsArray) {
            [ordered]@{ type = 'array'; items = @{ type = ConvertTo-JsonSchemaType $type.GetElementType() } }
        }
        else {
            [ordered]@{ type = ConvertTo-JsonSchemaType $type }
        }

        # [ValidateSet()] becomes a list of the only allowed values
        $validateSet = $parameter.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }
        if ($validateSet) { $schema.enum = @($validateSet.ValidValues) }

        # .PARAMETER help becomes the parameter's description
        $parameterHelp = $help.parameters.parameter | Where-Object name -eq $parameter.Name
        $description = ($parameterHelp.description.Text -join ' ').Trim()
        if ($parameter.Name -eq 'WhatIf') { $description = 'Preview the change without making it.' }
        if ($description) { $schema.description = $description }

        $properties[$parameter.Name] = $schema

        # Required means mandatory in every way of calling the command (every parameter set)
        $mandatoryEverywhere = $Info.ParameterSets | ForEach-Object {
            [bool]($_.Parameters | Where-Object { $_.Name -eq $parameter.Name -and $_.IsMandatory })
        }
        if ($mandatoryEverywhere -notcontains $false) { $required.Add($parameter.Name) }
    }

    $inputSchema = [ordered]@{ type = 'object'; properties = $properties; additionalProperties = $false }
    if ($required.Count) { $inputSchema.required = $required }

    [ordered]@{
        name        = $Info.Name
        description = $text -join "`n`n"
        inputSchema = $inputSchema
        annotations = [ordered]@{
            readOnlyHint    = $Info.Verb -in $readOnlyVerbs
            destructiveHint = $Info.Verb -in $destructiveVerbs
        }
    }
}

$tools = foreach ($name in $Command) { ConvertTo-McpTool (Get-Command $name) }

if ($ListTools) {
    $tools | ForEach-Object { [pscustomobject]$_ }
    return
}

# ---------------------------------------------------------------------------------------------
# 2. Run a tool call as a normal PowerShell command.
# ---------------------------------------------------------------------------------------------
function Invoke-McpTool([string] $Name, [System.Collections.IDictionary] $Arguments) {
    $ErrorActionPreference = 'Continue'
    $info = Get-Command $Name
    $tool = $tools | Where-Object { $_.name -eq $Name }

    # Anything marked ConfirmImpact = 'High' needs a human, even if someone adds it to the allowlist.
    $binding = $info.ScriptBlock.Attributes | Where-Object { $_ -is [System.Management.Automation.CmdletBindingAttribute] }
    if ($binding.ConfirmImpact -eq 'High') {
        return "$Name changes things that can't be undone, so a person has to run it. Try: $Name -WhatIf", $true
    }

    # Only pass parameters we advertised. (No sneaking in -Confirm:$false.)
    $splat = @{}
    foreach ($key in $Arguments.Keys) {
        if ($tool.inputSchema.properties.Contains($key)) { $splat[$key] = $Arguments[$key] }
    }
    Write-McpLog "tools/call $Name $(ConvertTo-Json $splat -Compress)"

    # -WhatIf messages print straight to the console. Catch them so they can't corrupt the protocol.
    $console = [IO.StringWriter]::new()
    [Console]::SetOut($console)
    try {
        $output = @(& $Name @splat 2>&1 3>$null 4>$null 5>$null 6>$null)
    }
    catch {
        $output = @($_)
    }
    finally {
        [Console]::SetOut([Console]::Error)
    }

    $errors  = @($output | Where-Object { $_ -is [System.Management.Automation.ErrorRecord] })
    $objects = @($output | Where-Object { $_ -isnot [System.Management.Automation.ErrorRecord] })

    $parts = [System.Collections.Generic.List[string]]::new()
    if ($objects.Count) { $parts.Add((ConvertTo-Json -InputObject $objects -Depth 5)) }
    if ($console.ToString().Trim()) { $parts.Add($console.ToString().Trim()) }
    foreach ($errorRecord in $errors) { $parts.Add("Error: $($errorRecord.Exception.Message)") }
    if (-not $parts.Count) { $parts.Add('No results.') }

    return ($parts -join "`n`n"), ($errors.Count -gt 0 -and $objects.Count -eq 0)
}

# ---------------------------------------------------------------------------------------------
# 3. Talk MCP: one JSON-RPC message per line on stdin, one reply per line on stdout.
# ---------------------------------------------------------------------------------------------
$utf8 = [Text.UTF8Encoding]::new($false)
$reader = [IO.StreamReader]::new([Console]::OpenStandardInput(), $utf8)
$writer = [IO.StreamWriter]::new([Console]::OpenStandardOutput(), $utf8)
$writer.AutoFlush = $true

# From here on, stdout belongs to the protocol. Anything else that prints goes to stderr.
[Console]::SetOut([Console]::Error)

function Send-Reply($Id, $Result, $ErrorInfo) {
    $message = [ordered]@{ jsonrpc = '2.0'; id = $Id }
    if ($ErrorInfo) { $message.error = $ErrorInfo } else { $message.result = $Result }
    $writer.WriteLine((ConvertTo-Json -InputObject $message -Depth 20 -Compress))
}

function New-Result([System.Collections.IDictionary] $Fields) {
    $result = [ordered]@{ resultType = 'complete' }
    foreach ($key in $Fields.Keys) { $result[$key] = $Fields[$key] }
    $result._meta = @{ 'io.modelcontextprotocol/serverInfo' = $serverInfo }
    $result
}

# Connect to the SIS with a key from the environment (VS Code prompts for it) or the vault.
$apiKey = if ($env:MULTIVERSIS_API_KEY) {
    ConvertTo-SecureString $env:MULTIVERSIS_API_KEY -AsPlainText -Force
}
else {
    try { Get-Secret -Name MultiverSIS } catch { Write-McpLog "No key in the vault: $($_.Exception.Message)" }
}
try {
    $uri = $env:MULTIVERSIS_URI ? $env:MULTIVERSIS_URI : 'http://localhost:8080'
    $null = Connect-MultiverSIS -Uri $uri -ApiKey $apiKey
    Write-McpLog "Connected to MultiverSIS at $uri. Tools: $($Command -join ', ')"
}
catch {
    Write-McpLog "Not connected: $($_.Exception.Message). Set MULTIVERSIS_API_KEY or run Set-Secret -Name MultiverSIS."
}

while ($null -ne ($line = $reader.ReadLine())) {
    if (-not $line.Trim()) { continue }

    try {
        $request = ConvertFrom-Json -InputObject $line -AsHashtable
    }
    catch {
        Send-Reply $null $null @{ code = -32700; message = 'Parse error' }
        continue
    }

    $id = $request['id']
    $method = $request['method']
    $params = $request['params'] ?? @{}
    if ($null -eq $id) { continue }   # a notification: no reply expected

    # Newer clients send their protocol version on every request.
    $requested = if ($params['_meta']) { $params['_meta']['io.modelcontextprotocol/protocolVersion'] }
    if ($requested -and $requested -notin $protocolVersions) {
        Send-Reply $id $null @{ code = -32022; message = 'Unsupported protocol version'; data = @{ supported = $protocolVersions; requested = $requested } }
        continue
    }

    try {
        if ($method -eq 'initialize') {
            # Older clients start with a handshake instead.
            $version = $params['protocolVersion'] -in $protocolVersions ? $params['protocolVersion'] : '2025-11-25'
            if ($version -eq '2026-07-28') { $version = '2025-11-25' }
            Send-Reply $id ([ordered]@{
                    protocolVersion = $version
                    capabilities    = @{ tools = @{ listChanged = $false } }
                    serverInfo      = $serverInfo
                    instructions    = $instructions
                })
        }
        elseif ($method -eq 'server/discover') {
            Send-Reply $id (New-Result ([ordered]@{
                        supportedVersions = $protocolVersions
                        capabilities      = @{ tools = @{} }
                        instructions      = $instructions
                        ttlMs             = 3600000
                        cacheScope        = 'private'
                    }))
        }
        elseif ($method -eq 'ping') {
            Send-Reply $id @{}
        }
        elseif ($method -eq 'tools/list') {
            Send-Reply $id (New-Result ([ordered]@{ tools = @($tools); ttlMs = 300000; cacheScope = 'private' }))
        }
        elseif ($method -eq 'tools/call') {
            $name = $params['name']
            if ($name -notin $Command) {
                Send-Reply $id $null @{ code = -32602; message = "Unknown tool: $name" }
                continue
            }
            $arguments = $params['arguments'] ?? @{}
            $text, $isError = Invoke-McpTool -Name $name -Arguments $arguments
            Send-Reply $id (New-Result ([ordered]@{
                        content = @(@{ type = 'text'; text = $text })
                        isError = [bool]$isError
                    }))
        }
        else {
            Send-Reply $id $null @{ code = -32601; message = "Method not found: $method" }
        }
    }
    catch {
        Write-McpLog "Error handling $method : $($_.Exception.Message)"
        Send-Reply $id $null @{ code = -32603; message = $_.Exception.Message }
    }
}
