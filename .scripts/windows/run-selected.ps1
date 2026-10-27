#Requires -Version 7.0

param(
    [Parameter(Mandatory)]
    [ValidateSet('record', 'restore')]
    [string]$Action,

    [AllowEmptyString()]
    [string]$Selected = '',

    [Parameter(Mandatory)]
    [string]$HelperDir,

    [switch]$Bootstrap
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$modules = @(
    & (Join-Path $PSScriptRoot 'select-modules.ps1') `
        -Selected $Selected `
        -ModulesFile (Join-Path $PSScriptRoot 'modules.json') `
        -HelperDir $HelperDir `
        -Bootstrap $Bootstrap.IsPresent
)

foreach ($module in $modules) {
    if ($module) {
        just "${module}::$Action"
    }
}
