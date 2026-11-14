function Remove-SISStudent {
    <#
    .SYNOPSIS
    Deletes a student from MultiverSIS. Permanently. Into another dimension.

    .DESCRIPTION
    Asks for confirmation every time, because ConfirmImpact is High.
    Add -Confirm:$false only if you're very sure. Maybe don't hand this one to an AI.

    .PARAMETER StudentId
    The student to delete. Accepts pipeline input by property name.

    .EXAMPLE
    Get-SISStudent -StudentId 1016 | Remove-SISStudent
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int] $StudentId
    )

    process {
        if ($PSCmdlet.ShouldProcess("Student $StudentId", 'Delete permanently')) {
            try {
                Invoke-SISApi -Method Delete -Path "/api/v1/students/$StudentId"
            }
            catch {
                Write-Error -Message $_.Exception.Message
            }
        }
    }
}
