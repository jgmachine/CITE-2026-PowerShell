function Get-SISStudent {
    <#
    .SYNOPSIS
    Gets students from MultiverSIS.

    .DESCRIPTION
    Returns student records from the MultiverSIS student information system.
    With no parameters, it returns every student. Combine parameters to narrow the results.

    .PARAMETER StudentId
    The student's ID number. Accepts pipeline input by property name.

    .PARAMETER Name
    All or part of the student's first or last name.

    .PARAMETER School
    The student's school, which is their home dimension, such as "Citadel of Ricks".
    Get-SISSchool lists them all.

    .PARAMETER Grade
    TK, K, or 1 through 12.

    .PARAMETER EnrollmentStatus
    Active, Withdrawn, or Unknown.

    .EXAMPLE
    Get-SISStudent -EnrollmentStatus Unknown

    Every student whose enrollment status is a shrug.

    .EXAMPLE
    Get-SISStudent -School 'Citadel of Ricks' | Export-Csv citadel.csv

    A roster for the principal, who wanted it "in Excel".
    #>
    [CmdletBinding(DefaultParameterSetName = 'Filter')]
    [OutputType('MultiverSIS.Student')]
    param(
        [Parameter(ParameterSetName = 'Id', Mandatory, ValueFromPipelineByPropertyName)]
        [int] $StudentId,

        [Parameter(ParameterSetName = 'Filter', Position = 0)]
        [string] $Name,

        [Parameter(ParameterSetName = 'Filter')]
        [string] $School,

        [Parameter(ParameterSetName = 'Filter')]
        [ValidateSet('TK', 'K', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12')]
        [string] $Grade,

        [Parameter(ParameterSetName = 'Filter')]
        [ValidateSet('Active', 'Withdrawn', 'Unknown')]
        [string] $EnrollmentStatus
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Id') {
            $students = Invoke-SISApi -Path "/api/v1/students/$StudentId"
        }
        else {
            $query = @{ name = $Name; school = $School; grade = $Grade; status = $EnrollmentStatus }
            $students = Invoke-SISApi -Path '/api/v1/students' -Query $query
        }

        foreach ($student in $students) {
            $student.PSObject.TypeNames.Insert(0, 'MultiverSIS.Student')
            $student
        }
    }
}
