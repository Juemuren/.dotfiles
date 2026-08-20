param(
    [Parameter(Mandatory = $true)]
    [string]$AppName
)

scoop info $AppName
| Select-Object -ExpandProperty Binaries
| ForEach-Object {
    $_ -split ' \| ' -replace '\.exe' -replace '.*\\'
} | Sort-Object
