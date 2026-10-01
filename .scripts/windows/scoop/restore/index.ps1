param(
    [Parameter(Mandatory)]
    [string]$Source
)

$ErrorActionPreference = 'Stop'

& "$PSScriptRoot/buckets.ps1" -Source (Join-Path $Source 'buckets.json')
& "$PSScriptRoot/apps.ps1" -Source (Join-Path $Source 'apps')
