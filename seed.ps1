#Requires -Version 5.1
<#
.SYNOPSIS
Install Scoop / Git / Mise for the current user.
#>
$ErrorActionPreference = 'Stop'

$installer = Invoke-RestMethod https://raw.githubusercontent.com/Juemuren/.dotfiles/master/scoop/automation/install.ps1
& ([scriptblock]::Create($installer))

$raw_scoop_bucket = "https://raw.githubusercontent.com/Juemuren/ScoopBucket/master/bucket"
scoop install "$raw_scoop_bucket/git.json"
scoop install "$raw_scoop_bucket/mise.json"
