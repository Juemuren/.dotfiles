#Requires -Version 7.0
[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSAvoidUsingPositionalParameters',
    '',
    Justification = 'scoop uses positional CLI subcommands and arguments.'
)]
param(
    [Parameter(Mandatory)]
    [string]$Source
)

Get-Content -LiteralPath $Source -Raw
| ConvertFrom-Json
| ForEach-Object { scoop bucket add $_.name $_.source }
