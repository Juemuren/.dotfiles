$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$selected = @(
    $env:MISE_ENV -split ',' | Where-Object { $_ }
)
$modulesFile = Join-Path $PSScriptRoot 'restore-modules.txt'

foreach ($module in Get-Content -LiteralPath $modulesFile) {
    if ($module -in $selected) {
        just "${module}::restore"
    }
}
