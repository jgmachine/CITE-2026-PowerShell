function ConvertTo-SISStudent {
    <#
    .SYNOPSIS
    Converts a character from the "vendor" API into a MultiverSIS student record.

    .DESCRIPTION
    Every district has a function like this. Most of them are called sync_FINAL_v2.ps1.

    The vendor says "status"; the SIS says "EnrollmentStatus". The vendor says "origin";
    we say "School". This function is where those translations (your business rules) live,
    so no other script has to know about them.

    Real data is messy, so it also handles one-word names ("Birdperson") and
    nicknames in parentheses ("Snuffles (Snowball)").

    It's also where you decide who doesn't come across at all. Characters whose name,
    origin, location, or type contains a word on the module's excluded list are skipped.
    Add -Verbose to see which ones.

    .PARAMETER InputObject
    A character from Get-RMCharacter.

    .EXAMPLE
    Get-RMCharacter -Name Morty | ConvertTo-SISStudent

    .EXAMPLE
    Get-RMCharacter -Id 1 | ConvertTo-SISStudent | Format-List *
    #>
    [CmdletBinding()]
    [OutputType('DistrictTools.StudentRecord')]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject] $InputObject
    )

    process {
        # District rule: some records stay with the vendor.
        $searchable = "$($InputObject.Name) $($InputObject.Origin) $($InputObject.Location) $($InputObject.Type)"
        foreach ($word in $script:ExcludedWords) {
            if ($searchable -like "*$word*") {
                Write-Verbose "Skipping $($InputObject.Name): matches excluded word '$word'."
                return
            }
        }

        $name = $InputObject.Name.Trim()

        # "Snuffles (Snowball)" -> legal name "Snuffles", preferred name "Snowball"
        $preferredName = $null
        if ($name -match '^(?<legal>.+?)\s*\((?<preferred>.+)\)$') {
            $name          = $Matches.legal
            $preferredName = $Matches.preferred
        }

        # "Rick Sanchez" -> "Rick", "Sanchez".  "Birdperson" -> "Birdperson", "" (one-name students exist!)
        $firstName, $lastName = $name -split '\s+', 2

        [pscustomobject]@{
            PSTypeName       = 'DistrictTools.StudentRecord'
            FirstName        = $firstName
            LastName         = "$lastName"
            PreferredName    = $preferredName
            Grade            = $script:Grades[$InputObject.Id % $script:Grades.Count]
            School           = if ($InputObject.Origin -eq 'unknown') { 'Unknown Dimension' } else { $InputObject.Origin }
            Program          = $script:Programs[$InputObject.Species] ?? 'General Education'
            EnrollmentStatus = $script:StatusMap[$InputObject.Status]
            AttendanceDays   = $InputObject.EpisodeCount
            Species          = $InputObject.Species
            Gender           = $InputObject.Gender
            LastSeen         = $InputObject.Location
            Notes            = $InputObject.Type
            SourceId         = $InputObject.Id
            Photo            = $InputObject.Image
        }
    }
}
