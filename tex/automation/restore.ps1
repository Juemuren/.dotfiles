#Requires -Version 7.0
param(
    [Parameter(Mandatory)]
    [string]$Source
)

$ErrorActionPreference = 'Stop'

Get-Content -LiteralPath $Source | ForEach-Object {
    tlmgr install $_
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install TeX package '$_' (exit code $LASTEXITCODE)."
    }
}
