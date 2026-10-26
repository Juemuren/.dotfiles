$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$modulesFile = Join-Path $PSScriptRoot 'restore-modules.txt'
$hasIncludeQuery = Join-Path $PSScriptRoot '../helper/has-include.jq'
$queryFile = Join-Path $PSScriptRoot '../helper/restore-selected.jq'
$configDir = Join-Path $PSScriptRoot '../../.mise'

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
