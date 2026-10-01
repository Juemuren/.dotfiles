#Requires -Version 5.1
<#
.SYNOPSIS
Install WSL itself; choose and initialize a distribution separately.
#>
[CmdletBinding(SupportsShouldProcess)]
param()

$ErrorActionPreference = 'Stop'

if (-not $PSCmdlet.ShouldProcess('WSL', 'Install without a Linux distribution')) {
    return
}

$process = Start-Process -FilePath 'wsl.exe' -ArgumentList '--install', '--no-distribution' `
    -Verb RunAs -WindowStyle Hidden -Wait -PassThru
$exitCode = $process.ExitCode

if ($exitCode -eq 3010) {
    # Installation succeeded; restart required.
    Write-Warning 'Restart Windows before using WSL.'
}
elseif ($exitCode -ne 0) {
    throw "WSL installation failed with exit code $exitCode."
}
