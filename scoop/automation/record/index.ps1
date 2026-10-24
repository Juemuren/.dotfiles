param(
    [Parameter(Mandatory)]
    [string]$Destination
)

& "$PSScriptRoot/buckets.ps1" -Destination (Join-Path $Destination 'buckets.json')
& "$PSScriptRoot/apps.ps1" -Destination (Join-Path $Destination 'apps')
