#Requires -Version 7.0

param(
    [Parameter(Mandatory)]
    [string]$ConfigDir,

    [Parameter(Mandatory)]
    [string]$HelperDir
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$modulesFile = Join-Path $PSScriptRoot 'restore-modules.txt'
$hasIncludeQuery = Join-Path $HelperDir 'has-include.jq'
$queryFile = Join-Path $HelperDir 'restore-selected.jq'

$includes = foreach ($module in Get-Content $modulesFile) {
    $configFile = Join-Path $configDir "config.$module.toml"
    $keys = mise config explain --file $configFile --json
    $hasInclude = $keys | jq -r -f $hasIncludeQuery
    if ($hasInclude -eq 'true') {
        $value = mise config get --file $configFile include
        "$module`t$value"
    }
}

$modules = @(
    $includes
    | jq -R -s -r `
        --arg selected ([string]$env:MISE_ENV) `
        --rawfile available $modulesFile `
        -f $queryFile
)

foreach ($module in $modules) {
    just "${module}::restore"
}
