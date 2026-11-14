function Invoke-SISApi {
    <#
    .SYNOPSIS
    Sends one request to the MultiverSIS API.

    .DESCRIPTION
    Private helper. Every public command goes through here, so the API key, the address,
    and the error handling live in exactly one place.
    #>
    [CmdletBinding()]
    param(
        [ValidateSet('Get', 'Post', 'Patch', 'Delete')]
        [string] $Method = 'Get',

        [Parameter(Mandatory)]
        [string] $Path,

        [hashtable] $Query = @{},

        [hashtable] $Body
    )

    if (-not $script:Connection) {
        throw 'Not connected to MultiverSIS. Run Connect-MultiverSIS first.'
    }

    $uri = $script:Connection.Uri + $Path
    $pairs = foreach ($key in $Query.Keys) {
        if ($Query[$key]) { '{0}={1}' -f $key, [uri]::EscapeDataString($Query[$key]) }
    }
    if ($pairs) { $uri += '?' + ($pairs -join '&') }

    $request = @{
        Method      = $Method
        Uri         = $uri
        # The key stays a SecureString until the moment it's needed.
        Headers     = @{ 'X-API-Key' = ConvertFrom-SecureString -SecureString $script:Connection.ApiKey -AsPlainText }
        ErrorAction = 'Stop'
    }
    if ($Body) {
        $request.Body        = $Body | ConvertTo-Json -Depth 5
        $request.ContentType = 'application/json'
    }

    Write-Verbose "$($Method.ToUpper()) $uri"
    try {
        # Invoke-RestMethod hands back a JSON array as one single object. Outputting it from
        # a variable sends the items down the pipeline one at a time, so Sort-Object and friends work.
        $response = Invoke-RestMethod @request
        $response
    }
    catch {
        $problem = $_

        # No response at all means we never reached the server.
        if (-not $problem.Exception.Response) {
            throw "MultiverSIS: Can't reach $($script:Connection.Uri) ($($problem.Exception.Message)). Is the server running? Try ./server/Start-MultiverSIS.ps1"
        }

        # The server explains itself in a JSON body like {"error": "..."}. Surface that message.
        $message = $problem.ErrorDetails.Message
        try { $message = ($message | ConvertFrom-Json).error } catch { Write-Verbose 'The error body was not JSON.' }
        throw "MultiverSIS: $($message ? $message : $problem.Exception.Message)"
    }
}
