@{
    RootModule        = 'RickMortyApi.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'd9cb15d2-aed8-4858-a3f4-c4e4e44c445c'
    Author            = 'CITE 2026: From Scripts to Systems'
    Description       = 'A tiny wrapper around the Rick and Morty API (rickandmortyapi.com). Our pretend "vendor API". Works offline, too.'
    PowerShellVersion = '7.4'

    # List exported functions by name. PowerShell reads this to autoload the module
    # the first time you type one of these commands.
    FunctionsToExport = @('Get-RMCharacter')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
