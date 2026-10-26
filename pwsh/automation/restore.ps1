#Requires -Version 7.0
param(
    [Parameter(Mandatory)]
    [string]$Source
)

$ErrorActionPreference = 'Stop'

Get-Content -LiteralPath $Source | ForEach-Object {
    Install-Module -Name $_ -Scope CurrentUser
}
