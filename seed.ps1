#Requires -Version 5.1
<#
.SYNOPSIS
Install Scoop / Git / Mise for the current user.
.PARAMETER ScoopDir
Installation directory.
Defaults to ~/scoop.
if set SCOOP_ROOT, defaults to SCOOP_ROOT.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$ScoopDir = $(
        if ($env:SCOOP_ROOT) { $env:SCOOP_ROOT }
        else { Join-Path $env:USERPROFILE 'scoop' }
    )
)

$ErrorActionPreference = 'Stop'

# https://github.com/ScoopInstaller/Install
$installer = Invoke-RestMethod https://get.scoop.sh
& ([scriptblock]::Create($installer)) -ScoopDir $ScoopDir

$raw_scoop_bucket = "https://raw.githubusercontent.com/Juemuren/ScoopBucket/master/bucket"
scoop install "$raw_scoop_bucket/git.json"
scoop install "$raw_scoop_bucket/mise.json"
