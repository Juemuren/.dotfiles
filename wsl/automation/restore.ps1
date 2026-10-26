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

$installed = @(& "$PSScriptRoot/helper/registered-distributions.ps1")
$seen = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
$requested = @(
    Get-Content -LiteralPath $Source -Encoding UTF8 |
        ForEach-Object { $_.Trim() } |
        Where-Object {
            $_ -and -not $_.StartsWith('#') -and $_ -notin $installed -and $seen.Add($_)
        }
)

foreach ($distribution in $requested) {
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
}
