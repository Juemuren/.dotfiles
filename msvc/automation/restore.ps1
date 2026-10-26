#Requires -Version 7.0
<#
.SYNOPSIS
Add the Visual Studio Build Tools components declared in a .vsconfig file.
.PARAMETER ConfigPath
Path to the Visual Studio configuration file.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [string]$ConfigPath
)

$ErrorActionPreference = 'Stop'

$config = (Resolve-Path -LiteralPath $ConfigPath).Path
$installerDirectory = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio/Installer'

$vswhere = Join-Path $installerDirectory 'vswhere.exe'
if (-not (Test-Path -LiteralPath $vswhere)) {
    throw 'Visual Studio Build Tools is not installed.'
}

$instance = & $vswhere -latest -products Microsoft.VisualStudio.Product.BuildTools -format json | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) {
    throw "Visual Studio Build Tools detection failed with exit code $LASTEXITCODE."
}
if (-not $instance) {
    throw 'Visual Studio Build Tools is not installed.'
}

if (-not $PSCmdlet.ShouldProcess('Visual Studio Build Tools', "Apply $config")) {
    return
}

$setup = Join-Path $installerDirectory 'setup.exe'
$arguments = @(
    'modify'
    '--installPath', ('"' + $instance.installationPath + '"')
    '--channelId', $instance.channelId
    '--config', ('"' + $config + '"')
    '--quiet',
    '--norestart'
)
$process = Start-Process -FilePath $setup -ArgumentList $arguments `
    -Verb RunAs -WindowStyle Hidden -Wait -PassThru
$exitCode = $process.ExitCode

if ($exitCode -eq 3010) {
    Write-Warning 'Restart Windows before using Visual Studio Build Tools.'
}
elseif ($exitCode -ne 0) {
    throw "Visual Studio Build Tools configuration failed with exit code $exitCode."
}
