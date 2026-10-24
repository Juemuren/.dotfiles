#Requires -Version 5.1
<#
.SYNOPSIS
Install Scoop for the current user; leave an existing installation in place.
.PARAMETER ScoopDir
Installation directory. Defaults to SCOOP, or ~/scoop when SCOOP is unset.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$ScoopDir = $(if ($env:SCOOP) { $env:SCOOP } else { Join-Path $env:USERPROFILE 'scoop' })
)

if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Output 'Scoop is already installed.'
    return
}

if (-not $PSCmdlet.ShouldProcess($ScoopDir, 'Download and install Scoop')) {
    return
}

$installer = Invoke-RestMethod https://get.scoop.sh
& ([scriptblock]::Create($installer)) -ScoopDir $ScoopDir
