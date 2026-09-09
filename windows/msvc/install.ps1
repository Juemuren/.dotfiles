#Requires -Version 5.1
<#
.SYNOPSIS
Install Visual Studio Build Tools or add items from .vsconfig to an existing installation.
#>
[CmdletBinding(SupportsShouldProcess)]
param()

$ErrorActionPreference = 'Stop'
$config = (Resolve-Path (Join-Path $PSScriptRoot '.vsconfig')).Path
$installerDirectory = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio/Installer'
$vswhere = Join-Path $installerDirectory 'vswhere.exe'
$instance = $null

if (Test-Path $vswhere) {
    $instance = & $vswhere -latest -products Microsoft.VisualStudio.Product.BuildTools -format json | ConvertFrom-Json
    if ($LASTEXITCODE -ne 0) {
        throw "Visual Studio Build Tools detection failed with exit code $LASTEXITCODE."
    }
}

if (-not $PSCmdlet.ShouldProcess('Visual Studio Build Tools', "Apply $config")) {
    return
}

if ($instance) {
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
}
else {
    $override = '--passive --wait --norestart --config ' + '"' + $config + '"'
    # PowerShell 5.1 and Legacy mode need escaped quotes for native commands.
    if ($PSVersionTable.PSVersion -lt [version]'7.3' -or $PSNativeCommandArgumentPassing -eq 'Legacy') {
        $override = $override.Replace('"', '\"')
    }
    winget install --id Microsoft.VisualStudio.BuildTools --exact --source winget `
        --silent --accept-package-agreements --accept-source-agreements `
        --override $override
    $exitCode = $LASTEXITCODE
}

if ($exitCode -eq 3010) {
    # Installation succeeded; restart required.
    Write-Warning 'Restart Windows before using Visual Studio Build Tools.'
}
elseif ($exitCode -ne 0) {
    throw "Visual Studio Build Tools configuration failed with exit code $exitCode."
}
