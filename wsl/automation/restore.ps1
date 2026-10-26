#Requires -Version 7.0
<#
.SYNOPSIS
Install missing WSL distributions listed in a text file.
.DESCRIPTION
Each nonempty, non-comment line names an installable WSL distribution.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [string]$Source
)

$ErrorActionPreference = 'Stop'

# Read the same per-user registrations used by record.ps1.
$registryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss'
$installed = @(
    if (Test-Path -LiteralPath $registryPath) {
        Get-ChildItem -LiteralPath $registryPath |
            ForEach-Object {
                (Get-ItemProperty -LiteralPath $_.PSPath).DistributionName
            } |
            Where-Object { $_ }
    }
)
$requested = @()

foreach ($line in Get-Content -LiteralPath $Source -Encoding UTF8) {
    $distribution = $line.Trim()
    if (-not $distribution -or $distribution.StartsWith('#') -or
        $distribution -in $installed -or $distribution -in $requested) {
        continue
    }
    $requested += $distribution

    if (-not $PSCmdlet.ShouldProcess($distribution, 'Install WSL distribution')) {
        continue
    }

    wsl.exe --install --distribution $distribution --no-launch
    if ($LASTEXITCODE -eq 3010) {
        Write-Warning "Restart Windows before using $distribution."
    }
    elseif ($LASTEXITCODE -ne 0) {
        throw "WSL distribution installation failed for '$distribution' with exit code $LASTEXITCODE."
    }
    $installed += $distribution
}
