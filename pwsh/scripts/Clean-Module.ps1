#Requires -Modules PowerShellGet

<#
.SYNOPSIS
Uninstalls older PowerShellGet-managed versions of a module, keeping the newest.

.PARAMETER ModuleName
Name of the installed module to clean.

.DESCRIPTION
Prompts before uninstalling. Use -WhatIf to preview or -Confirm:$false to skip confirmation.

.EXAMPLE
Clean-Module.ps1 Pester -WhatIf
#>
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param(
    [Parameter(Mandatory, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]$ModuleName
)

$ErrorActionPreference = 'Stop'

$modules = @(
    Get-InstalledModule -Name $ModuleName -AllVersions
    | Sort-Object Version -Descending
)
if ($modules.Count -eq 0) {
    throw "'$ModuleName' is not installed."
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

if (-not $PSCmdlet.ShouldProcess($ModuleName, 'Uninstall the old versions')) {
    return
}

$oldModules | ForEach-Object {
    Write-Output "Uninstalling $($_.Name) $($_.Version) ..."
    Uninstall-Module -InputObject $_ -Confirm:$false
}
