[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param(
    [Parameter(Mandatory, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]$ModuleName
)

$modules = @(
    Get-InstalledModule -Name $ModuleName -AllVersions -ErrorAction SilentlyContinue
    | Sort-Object Version -Descending
)
if ($modules.Count -eq 0) {
    Write-Error "'$ModuleName' is not installed."
    return
}

$latestModule = $modules | Select-Object -First 1
$oldModules = @($modules | Select-Object -Skip 1)
if ($oldModules.Count -eq 0) {
    Write-Output "'$ModuleName' only installed version $($latestModule.Version)."
    return
}

Write-Output "Latest version: $($latestModule.Version)"
Write-Output 'The following versions will be uninstalled:'
$oldModules.Version | ForEach-Object {
    Write-Output "  - $_"
}

if (-not $PSCmdlet.ShouldProcess($ModuleName, 'Uninstall the versions listed above')) {
    return
}

$oldModules | Uninstall-Module -Confirm:$false
