function Connect-MultiverSIS {
    <#
    .SYNOPSIS
    Connects to a MultiverSIS server so the other commands know where to go.

    .DESCRIPTION
    Stores the server address and API key in memory for this PowerShell session only.
    Nothing is written to disk. Then it checks the key actually works.

    .PARAMETER Uri
    The server address. Defaults to http://localhost:8080.

    .PARAMETER ApiKey
    The API key as a SecureString. Leave it out and you'll be prompted.

    .EXAMPLE
    Connect-MultiverSIS -ApiKey (Get-Secret MultiverSIS)

    Reads the key from your SecretManagement vault. (That's Act 4.)

    .EXAMPLE
    Connect-MultiverSIS

    Prompts for the key. Fine for today; useless for a 2 a.m. scheduled task.
    #>
    [CmdletBinding()]
    param(
        [string] $Uri = 'http://localhost:8080',

        [securestring] $ApiKey
    )

    if (-not $ApiKey) {
        $ApiKey = Read-Host -Prompt 'MultiverSIS API key' -AsSecureString
    }

    $script:Connection = @{ Uri = $Uri.TrimEnd('/'); ApiKey = $ApiKey }

    try {
        Invoke-SISApi -Path '/api/v1/about'
    }
    catch {
        $script:Connection = $null
        throw
    }
}
