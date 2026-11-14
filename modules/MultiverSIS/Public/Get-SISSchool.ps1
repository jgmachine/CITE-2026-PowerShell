function Get-SISSchool {
    <#
    .SYNOPSIS
    Lists the schools in MultiverSIS and how many students each one has.

    .DESCRIPTION
    Every school is a home dimension, such as "Earth (C-137)" or "Citadel of Ricks".
    Use these exact names with Get-SISStudent -School.

    .EXAMPLE
    Get-SISSchool | Sort-Object Students -Descending
    #>
    [CmdletBinding()]
    param()

    Invoke-SISApi -Path '/api/v1/schools'
}
