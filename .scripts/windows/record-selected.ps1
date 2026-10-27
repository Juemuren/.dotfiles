#Requires -Version 7.0

param(
    [Parameter(Mandatory)]
    [string]$ConfigDir,

    [Parameter(Mandatory)]
    [string]$HelperDir
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$modulesFile = Join-Path $PSScriptRoot 'modules.txt'
$modules = @(
    & (Join-Path $HelperDir 'modules.ps1') `
        -ConfigDir $ConfigDir `
        -HelperDir $HelperDir `
        -ModulesFile $modulesFile
)

foreach ($module in $modules) {
    if ($module) {
        just "${module}::record"
    }
}
