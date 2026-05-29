param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$ModuleName
)

$versions = Get-Module -All -Name $ModuleName |
ForEach-Object {
    $_.Version
}
if (-not $versions) {
    Write-Host "$ModuleName has not been installed"
    exit
}

$latestVersion = $versions[0]
$oldVersions = $versions[1..$versions.Count]
if (-not $oldVersions) {
    Write-Host "$ModuleName only has $latestVersion installed"
    exit
}

Write-Host "latest version: $latestVersion"
Write-Host "the following version will be deleted:"
$oldVersions | ForEach-Object {
    Write-Host "  - $_"
}
$confirm = Read-Host "Confirm deleting (y/N)"
if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host "Cancelled"
    exit
}

$oldVersions | ForEach-Object {
    Write-Host "Deleting $ModuleName $_"
    Uninstall-Module -Name $ModuleName -RequiredVersion $_
}
