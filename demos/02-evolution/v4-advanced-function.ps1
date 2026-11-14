# v4: The advanced function. It behaves like a real cmdlet.
#   [CmdletBinding()]  -> -Verbose, -ErrorAction and friends, for free
#   [string]           -> typed parameters
#   [ValidateSet()]    -> tab completion, and typos get caught before they reach the API
#   Write-Verbose      -> quiet by default, chatty when you ask
#   [pscustomobject]   -> clean, flat output objects in *your* words, not the vendor's

function Get-RMCharacter {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string] $Name,

        [ValidateSet('Alive', 'Dead', 'unknown')]
        [string] $Status
    )

    $url = "https://rickandmortyapi.com/api/character/?name=$Name&status=$Status"
    while ($url) {
        Write-Verbose "GET $url"
        $page = Invoke-RestMethod $url
        foreach ($c in $page.results) {
            [pscustomobject]@{
                Id      = $c.id
                Name    = $c.name
                Status  = $c.status
                Species = $c.species
                Origin  = $c.origin.name
            }
        }
        $url = $page.info.next
    }
}
