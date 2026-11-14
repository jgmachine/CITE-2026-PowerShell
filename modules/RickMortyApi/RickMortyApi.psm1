# RickMortyApi: our pretend "vendor API" module.

$script:BaseUri      = 'https://rickandmortyapi.com/api'
$script:SnapshotPath = Join-Path $PSScriptRoot 'Data/characters.json'

# Conference Wi-Fi insurance: set $env:RMAPI_OFFLINE = 1 before importing to skip the network entirely.
$script:Offline = [bool]$env:RMAPI_OFFLINE

# Load private helpers and public functions. One function per file keeps things easy to find.
foreach ($file in Get-ChildItem -Path "$PSScriptRoot/Private/*.ps1", "$PSScriptRoot/Public/*.ps1") {
    . $file.FullName
}

# Four properties or fewer means a table by default. Every property is still there: try | Format-List *
Update-TypeData -TypeName 'RickMorty.Character' -DefaultDisplayPropertySet Id, Name, Status, Species -Force
