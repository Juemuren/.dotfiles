param(
    [Parameter(Mandatory)]
    [string]$Source
)

Get-Content -LiteralPath $Source | ForEach-Object {
    Install-Module -Name $_
}
