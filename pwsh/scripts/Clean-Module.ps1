param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$ModuleName
)

$versions = @(
    Get-InstalledModule -AllVersions -Name $ModuleName | ForEach-Object {
        $_.Version
    } | Sort-Object -Descending
)
if (-not $versions) {
    Write-Host "$ModuleName has not been installed"
    exit
}

$latestVersion = $versions | Select-Object -First 1
$oldVersions = @($versions | Select-Object -Skip 1)
if (-not $oldVersions) {
    Write-Host "$ModuleName only installed $latestVersion"
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
