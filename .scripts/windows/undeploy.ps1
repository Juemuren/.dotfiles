param([Parameter(Mandatory)][string]$DotfilesRoot)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

Set-Location -LiteralPath $DotfilesRoot

$targets = @(
    (mise dot status --json | ConvertFrom-Json).files | Where-Object {
        $_.state -eq 'applied'
    } | ForEach-Object {
        Get-Item -Path $_.target
    }
)

$junctions = @(
    $targets | Where-Object LinkType -EQ 'Junction'
)

$nonJunctions = @(
    $targets | Where-Object {
        $_.LinkType -ne 'Junction'
    } | ForEach-Object {
        $_.FullName
    }
)

if ($nonJunctions.Count) {
    mise dot unapply --yes @nonJunctions
}

$junctions | ForEach-Object {
    [System.IO.Directory]::Delete($_.FullName)
}
