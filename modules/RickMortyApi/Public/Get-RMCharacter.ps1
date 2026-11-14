function Get-RMCharacter {
    <#
    .SYNOPSIS
    Gets characters from the Rick and Morty API.

    .DESCRIPTION
    Wraps https://rickandmortyapi.com so you never have to think about URLs, query strings,
    or pagination again. Returns one clean object per character.

    If the API can't be reached (hello, conference Wi-Fi), it switches to the offline
    snapshot that ships with this module.

    .PARAMETER Name
    All or part of a character's name. "rick" matches Rick Sanchez, Pickle Rick, and 105 others.

    .PARAMETER Status
    Alive, Dead, or unknown.

    .PARAMETER Species
    All or part of a species, such as Human, Alien, or Robot.

    .PARAMETER Id
    One or more character IDs. Accepts pipeline input.

    .EXAMPLE
    Get-RMCharacter -Name rick -Status Alive

    Every living Rick.

    .EXAMPLE
    1, 2, 3 | Get-RMCharacter

    Characters 1, 2 and 3, by ID.

    .EXAMPLE
    Get-RMCharacter -Species Robot | Sort-Object EpisodeCount -Descending | Select-Object -First 5

    The five robots with the most screen time.

    .LINK
    https://rickandmortyapi.com/documentation
    #>
    [CmdletBinding(DefaultParameterSetName = 'Search')]
    [OutputType('RickMorty.Character')]
    param(
        [Parameter(ParameterSetName = 'Search', Position = 0)]
        [string] $Name,

        [Parameter(ParameterSetName = 'Search')]
        [ValidateSet('Alive', 'Dead', 'unknown')]
        [string] $Status,

        [Parameter(ParameterSetName = 'Search')]
        [string] $Species,

        [Parameter(ParameterSetName = 'Id', Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [int[]] $Id
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Id') {
            $characters = Invoke-RMApi -Path "/character/$($Id -join ',')"
        }
        else {
            $query = @{}
            if ($Name)    { $query.name    = $Name }
            if ($Status)  { $query.status  = $Status }
            if ($Species) { $query.species = $Species }
            $characters = Invoke-RMApi -Path '/character' -Query $query
        }

        # Translate vendor-speak into a flat, friendly object.
        foreach ($c in $characters) {
            [pscustomobject]@{
                PSTypeName   = 'RickMorty.Character'
                Id           = $c.id
                Name         = $c.name
                Status       = $c.status
                Species      = $c.species
                Type         = $c.type
                Gender       = $c.gender
                Origin       = $c.origin.name
                Location     = $c.location.name
                EpisodeCount = @($c.episode).Count
                Image        = $c.image
            }
        }
    }
}
