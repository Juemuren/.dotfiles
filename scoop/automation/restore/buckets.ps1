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

$ErrorActionPreference = 'Stop'
$bucketAlreadyExistsExitCode = 2

Get-Content -LiteralPath $Source -Raw
| ConvertFrom-Json
| ForEach-Object {
    scoop bucket add $_.name $_.source
    if ($LASTEXITCODE -notin 0, $bucketAlreadyExistsExitCode) {
        throw "Failed to add Scoop bucket '$($_.name)' (exit code $LASTEXITCODE)."
    }
}
