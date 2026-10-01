param(
    [Parameter(Mandatory)]
    [string]$Source
)

Get-Content -LiteralPath $Source -Raw
| ConvertFrom-Json
| ForEach-Object { scoop bucket add $_.name $_.source }
