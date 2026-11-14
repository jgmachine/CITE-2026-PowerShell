@{
    RootModule        = 'DistrictTools.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '0a06ff13-939a-48e9-b738-ff79f977856d'
    Author            = 'CITE 2026: From Scripts to Systems'
    Description       = 'Your district''s business rules as reusable bricks: turning records from another system into records for your SIS.'
    PowerShellVersion = '7.4'

    FunctionsToExport = @(
        'ConvertTo-SISStudent'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
