#Requires -Version 5.1
<#
.SYNOPSIS
Install Scoop for the current user; leave an existing installation in place.
.PARAMETER ScoopDir
Installation directory.
Defaults to ~/scoop.
if set SCOOP_ROOT, defaults to SCOOP_ROOT.
#>
param(
    [string]$ScoopDir = $(
        if ($env:SCOOP_ROOT) {
            $env:SCOOP_ROOT
        }
        else {
            Join-Path $env:USERPROFILE 'scoop'
        }
    )
)

$ErrorActionPreference = 'Stop'

if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Output 'Scoop is already installed.'
    return
}

$installer = Invoke-RestMethod https://get.scoop.sh
& ([scriptblock]::Create($installer)) -ScoopDir $ScoopDir
