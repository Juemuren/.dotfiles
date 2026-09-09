param(
    [Parameter(Mandatory)]
    [string]$Source
)

$ErrorActionPreference = 'Stop'

Get-ChildItem -LiteralPath $Source -Filter '*.txt' -File
| ForEach-Object {
    $bucket = $_.BaseName
    $apps = @(
        Get-Content -LiteralPath $_.FullName
        | ForEach-Object { "$bucket/$_" }
    )
    scoop install @apps
}
