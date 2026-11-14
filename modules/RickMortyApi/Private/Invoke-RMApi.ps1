function Invoke-RMApi {
    <#
    .SYNOPSIS
    Calls the Rick and Morty API and follows every page of results.

    .DESCRIPTION
    Private helper. It handles the two things every vendor API makes you handle:

    1. Pagination. The API returns 20 results per page, plus a link to the next page.
    2. The network going away. If the API can't be reached, it switches to the
       offline snapshot that ships with this module and filters that instead.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [hashtable] $Query = @{}
    )

    if (-not $script:Offline) {
        $uri = $script:BaseUri + $Path
        if ($Query.Count) {
            $pairs = foreach ($key in $Query.Keys) { '{0}={1}' -f $key, [uri]::EscapeDataString($Query[$key]) }
            $uri += '?' + ($pairs -join '&')
        }

        $pageCount = 0
        try {
            while ($uri) {
                $pageCount++
                Write-Verbose "GET $uri"
                $response = Invoke-RestMethod -Uri $uri -TimeoutSec 10 -ErrorAction Stop

                # A captive portal login page comes back as HTML, not data.
                if ($response -is [string]) { throw 'Expected JSON but got a web page. Captive portal?' }

                if ($response.PSObject.Properties.Name -contains 'results') {
                    $response.results            # one page of results
                    $uri = $response.info.next   # $null on the last page, which ends the loop
                }
                else {
                    $response                    # lookups by ID aren't paginated
                    $uri = $null
                }
            }
            return
        }
        catch {
            # The API answers "404: There is nothing here" when a search has no matches.
            if ($_.Exception.Response.StatusCode -eq [System.Net.HttpStatusCode]::NotFound) { return }

            # Failing halfway through would mix online and offline results, so only fall back on page 1.
            if ($pageCount -gt 1) { throw }

            Write-Warning "Can't reach the Rick and Morty API ($($_.Exception.Message)). Using the offline snapshot."
            $script:Offline = $true
        }
    }

    # Offline: filter the snapshot the same way the real API does.
    if (-not $script:Snapshot) {
        $script:Snapshot = Get-Content -Path $script:SnapshotPath -Raw | ConvertFrom-Json
    }

    if ($Path -match '^/character/(?<ids>[\d,]+)$') {
        $ids = [int[]]($Matches.ids -split ',')
        $script:Snapshot | Where-Object id -in $ids
        return
    }

    $script:Snapshot | Where-Object {
        # name, species and type are partial matches; status and gender must match exactly.
        (-not $Query.name    -or $_.name    -match [regex]::Escape($Query.name)) -and
        (-not $Query.species -or $_.species -match [regex]::Escape($Query.species)) -and
        (-not $Query.type    -or $_.type    -match [regex]::Escape($Query.type)) -and
        (-not $Query.status  -or $_.status  -eq $Query.status) -and
        (-not $Query.gender  -or $_.gender  -eq $Query.gender)
    }
}
