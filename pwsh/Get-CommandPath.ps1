param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$CommandName
)

$cmd = Get-Command $CommandName
if (-not $cmd.Source) {
    Write-Host "Command has no source file" -ForegroundColor Red
    exit 1
}

Write-Host $cmd.Source
