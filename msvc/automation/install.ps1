#Requires -Version 5.1
<#
.SYNOPSIS
Install the base Visual Studio Build Tools product without additional components.
.PARAMETER InstallPath
Installation directory for a new installation. Existing installations keep their current directory.
.EXAMPLE
./install.ps1 -InstallPath 'D:\Microsoft Visual Studio\BuildTools'
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [ValidateNotNullOrEmpty()]
    [string]$InstallPath
)

$ErrorActionPreference = 'Stop'

$installerDirectory = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio/Installer'
$vswhere = Join-Path $installerDirectory 'vswhere.exe'

if (Test-Path $vswhere) {
    $instance = & $vswhere -latest -products Microsoft.VisualStudio.Product.BuildTools -format json | ConvertFrom-Json
    if ($LASTEXITCODE -ne 0) {
        throw "Visual Studio Build Tools detection failed with exit code $LASTEXITCODE."
    }
    if ($instance) {
        Write-Output 'Visual Studio Build Tools is already installed.'
        return
    }
}

if (-not $PSCmdlet.ShouldProcess('Visual Studio Build Tools', 'Install base product')) {
    return
}

$override = '--quiet --wait --norestart'
if ($InstallPath) {
    $override += ' --installPath "' + $InstallPath.TrimEnd('\') + '"'
}
# PowerShell 5.1 and Legacy mode need escaped quotes for native commands.
if ($PSVersionTable.PSVersion -lt [version]'7.3' -or $PSNativeCommandArgumentPassing -eq 'Legacy') {
    $override = $override.Replace('"', '\"')
}
winget install --id Microsoft.VisualStudio.BuildTools --exact --source winget `
    --disable-interactivity --silent --accept-package-agreements --accept-source-agreements `
    --override $override
$exitCode = $LASTEXITCODE

if ($exitCode -eq 3010) {
    # Installation succeeded; restart required.
    Write-Warning 'Restart Windows before using Visual Studio Build Tools.'
}
elseif ($exitCode -ne 0) {
    throw "Visual Studio Build Tools configuration failed with exit code $exitCode."
}
