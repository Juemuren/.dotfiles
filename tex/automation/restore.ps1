#Requires -Version 7.0
param(
    [Parameter(Mandatory)]
    [string]$Source
)

Get-Content -LiteralPath $Source | ForEach-Object {
    tlmgr install $_
}
