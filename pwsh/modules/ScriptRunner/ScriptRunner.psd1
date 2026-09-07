@{
    RootModule        = 'ScriptRunner.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = '79fc1014-2140-4bae-86f1-b36d64d969f2'
    Author            = 'Raind'
    Description       = 'Run local scripts with an interpreter selected from their shebang.'
    PowerShellVersion = '7.0'

    FunctionsToExport = @(
        'Invoke-LocalScript'
        'Get-LocalScript'
        'Get-ScriptInterpreter'
        'Enable-ScriptPicker'
    )
    AliasesToExport   = @('runs')
    CmdletsToExport   = @()
    VariablesToExport = @()
}
