param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$CommandName
)

$cmd = Get-Command $CommandName
if (-not $cmd.Source) {
    Write-Error "$CommandName has no source file"
    exit 1
}

Get-Content $cmd.Source
