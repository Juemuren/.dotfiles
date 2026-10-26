#Requires -Version 7.0
param(
    [Parameter(Mandatory)]
    [string]$Destination
)

Get-InstalledModule | Select-Object -ExpandProperty Name > $Destination
