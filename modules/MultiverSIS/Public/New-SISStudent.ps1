function New-SISStudent {
    <#
    .SYNOPSIS
    Creates students in MultiverSIS.

    .DESCRIPTION
    Creates one student per input object. It's built to sit at the end of a pipeline:
    every parameter can come from a property of the object you pipe in.

    Supports -WhatIf, so you can see exactly what would happen before anything does.
    If one student fails (say, they're already in the SIS), the rest keep going.

    .PARAMETER FirstName
    The student's first name.

    .PARAMETER LastName
    The student's last name. Can be empty.

    .PARAMETER PreferredName
    The name the student actually goes by.

    .PARAMETER Grade
    TK, K, or 1 through 12.

    .PARAMETER School
    The student's school (home dimension).

    .PARAMETER Program
    The student's program, such as General Education.

    .PARAMETER EnrollmentStatus
    Active, Withdrawn, or Unknown. Defaults to Active.

    .PARAMETER AttendanceDays
    Days attended so far.

    .PARAMETER Species
    The student's species. It's that kind of district.

    .PARAMETER Gender
    The student's gender, as the source system recorded it.

    .PARAMETER LastSeen
    Where the student was last seen.

    .PARAMETER Notes
    Anything else worth knowing about the student.

    .PARAMETER SourceId
    The student's ID in the system they came from. MultiverSIS refuses duplicates.

    .PARAMETER Photo
    A link to the student's photo.

    .EXAMPLE
    Get-RMCharacter -Name Rick | ConvertTo-SISStudent | New-SISStudent -WhatIf

    Shows what would be created, without creating anything.

    .EXAMPLE
    New-SISStudent -FirstName Squanchy -Grade 7 -School 'Planet Squanch'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('MultiverSIS.Student')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $FirstName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $LastName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $PreferredName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Grade,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $School,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Program,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Active', 'Withdrawn', 'Unknown')]
        [string] $EnrollmentStatus = 'Active',

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $AttendanceDays,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Species,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Gender,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $LastSeen,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Notes,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $SourceId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Photo
    )

    process {
        $body = @{ FirstName = $FirstName; EnrollmentStatus = $EnrollmentStatus }
        foreach ($field in 'LastName', 'PreferredName', 'Grade', 'School', 'Program', 'AttendanceDays', 'Species', 'Gender', 'LastSeen', 'Notes', 'SourceId', 'Photo') {
            if ("$($PSBoundParameters[$field])" -ne '') { $body[$field] = $PSBoundParameters[$field] }
        }

        if ($PSCmdlet.ShouldProcess("$FirstName $LastName".Trim(), 'Create student')) {
            try {
                $student = Invoke-SISApi -Method Post -Path '/api/v1/students' -Body $body
            }
            catch {
                # Report this one failure and move on to the next student.
                Write-Error -Message $_.Exception.Message
                return
            }
            $student.PSObject.TypeNames.Insert(0, 'MultiverSIS.Student')
            $student
        }
    }
}
