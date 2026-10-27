#Requires -Version 7.0

param(
    [Parameter(Mandatory)]
    [AllowEmptyString()]
    [string]$Selected,

    [Parameter(Mandatory)]
    [string]$ModulesFile,

    [Parameter(Mandatory)]
    [string]$HelperDir,

    [bool]$Bootstrap = $false
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

jq -r `
    --arg selected $Selected `
    --argjson bootstrap $Bootstrap.ToString().ToLowerInvariant() `
    -f (Join-Path $HelperDir 'select-modules.jq') `
    $ModulesFile
