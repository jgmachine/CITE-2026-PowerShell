@{
    RootModule        = 'MultiverSIS.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '458e0b45-ab8a-4465-8897-d516d2570d67'
    Author            = 'CITE 2026: From Scripts to Systems'
    Description       = 'Client for MultiverSIS, the Multiverse Student Information System.'
    PowerShellVersion = '7.4'

    FunctionsToExport = @(
        'Connect-MultiverSIS'
        'Get-SISStudent'
        'New-SISStudent'
        'Set-SISStudent'
        'Remove-SISStudent'
        'Get-SISSchool'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
