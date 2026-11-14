function Set-SISStudent {
    <#
    .SYNOPSIS
    Changes a student's record in MultiverSIS.

    .DESCRIPTION
    Updates only the fields you specify. Everything else stays as it was.

    .PARAMETER StudentId
    The student to change. Accepts pipeline input by property name.

    .PARAMETER EnrollmentStatus
    Active, Withdrawn, or Unknown.

    .PARAMETER School
    The student's new school.

    .PARAMETER Grade
    TK, K, or 1 through 12.

    .PARAMETER Program
    The student's new program.

    .PARAMETER PreferredName
    The name the student goes by.

    .EXAMPLE
    Get-SISStudent -Name 'Cronenberg' | Set-SISStudent -EnrollmentStatus Withdrawn -WhatIf
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('MultiverSIS.Student')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int] $StudentId,

        [ValidateSet('Active', 'Withdrawn', 'Unknown')]
        [string] $EnrollmentStatus,

        [string] $School,

        [ValidateSet('TK', 'K', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12')]
        [string] $Grade,

        [string] $Program,

        [string] $PreferredName
    )

    process {
        $changes = @{}
        foreach ($field in 'EnrollmentStatus', 'School', 'Grade', 'Program', 'PreferredName') {
            if ($PSBoundParameters.ContainsKey($field)) { $changes[$field] = $PSBoundParameters[$field] }
        }

        $summary = ($changes.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join ', '
        if ($PSCmdlet.ShouldProcess("Student $StudentId", "Set $summary")) {
            try {
                $student = Invoke-SISApi -Method Patch -Path "/api/v1/students/$StudentId" -Body $changes
            }
            catch {
                Write-Error -Message $_.Exception.Message
                return
            }
            $student.PSObject.TypeNames.Insert(0, 'MultiverSIS.Student')
            $student
        }
    }
}
