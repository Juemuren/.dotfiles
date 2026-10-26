#Requires -Version 7.0

$ErrorActionPreference = 'Stop'

# wsl --list output is unreliable when redirected.
$registryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss'
if (Test-Path -LiteralPath $registryPath) {
    Get-ChildItem -LiteralPath $registryPath |
        ForEach-Object { (Get-ItemProperty -LiteralPath $_.PSPath).DistributionName } |
        Where-Object { $_ } |
        Sort-Object -Unique
}
