param(
    [Parameter(Mandatory)]
    [string]$Source
)

Get-Content -LiteralPath $Source | ForEach-Object {
    tlmgr install $_
}
