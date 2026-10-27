#Requires -Version 7.0

param(
    [Parameter(Mandatory)]
    [string]$ConfigDir,

    [Parameter(Mandatory)]
    [string]$HelperDir,

    [Parameter(Mandatory)]
    [string]$ModulesFile
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$hasIncludeQuery = Join-Path $HelperDir 'has-include.jq'
$queryFile = Join-Path $HelperDir 'select-modules.jq'

$includeRecords = foreach ($module in Get-Content $ModulesFile) {
    $configFile = Join-Path $ConfigDir "config.$module.toml"
    $configKeys = mise config explain --file $configFile --json
    $hasInclude = $configKeys | jq -r -f $hasIncludeQuery
    if ($hasInclude -eq 'true') {
        $includeJson = mise config get --file $configFile include
        "$module`t$includeJson"
    }
}

$includeRecords |
    jq -R -s -r `
        --arg selected ([string]$env:MISE_ENV) `
        --rawfile available $ModulesFile `
        -f $queryFile
