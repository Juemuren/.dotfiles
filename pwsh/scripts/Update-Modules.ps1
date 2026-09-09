#Requires -Modules PowerShellGet

<#
.SYNOPSIS
Selects available PowerShellGet module updates with fzf and installs them.

.DESCRIPTION
Requires fzf. Checks each installed module's registered repository.
Tab toggles selection, Ctrl+A selects all, Enter updates, and Esc cancels.
Use -WhatIf to preview or -Confirm to prompt before each update.
Check failures are reported separately from update failures.

.EXAMPLE
Update-Modules.ps1 -WhatIf
#>
[CmdletBinding(SupportsShouldProcess)]
param()

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

$modules = @(Get-InstalledModule | Sort-Object Name)
if ($modules.Count -eq 0) {
    Write-Output 'No PowerShellGet-managed modules are installed.'
    return
}

Write-Information 'Checking for module updates...' -InformationAction Continue
$failedChecks = [System.Collections.Generic.List[string]]::new()
$updates = @(
    foreach ($module in $modules) {
        try {
            $latest = Find-Module -Name $module.Name -Repository $module.Repository
            if ($latest.Version -gt $module.Version) {
                [PSCustomObject]@{
                    Name             = $module.Name
                    InstalledVersion = $module.Version
                    LatestVersion    = $latest.Version
                    Repository       = $module.Repository
                }
            }
        }
        catch {
            Write-Warning "Could not check '$($module.Name)': $_"
            $failedChecks.Add($module.Name)
        }
    }
)

if ($failedChecks.Count -gt 0) {
    Write-Warning "Update checks incomplete for: $($failedChecks -join ', ')."
}
if ($updates.Count -eq 0) {
    if ($failedChecks.Count -gt 0) {
        throw 'Could not complete update checks; no updates are available to select.'
    }
    Write-Output 'No updates found.'
    return
}

$selection = @(
    $updates | ForEach-Object {
        "$($_.Name)`t$($_.InstalledVersion) -> $($_.LatestVersion)`t$($_.Repository)"
    } | fzf --multi --delimiter="`t" `
        --height=60% `
        --layout=reverse `
        --prompt='update> ' `
        --header='Tab: select | Ctrl+A: select all | Enter: update | Esc: cancel' `
        --bind='ctrl-a:select-all'
)
$fzfNoMatchExitCode = 1
$fzfCancelledExitCode = 130
if ($LASTEXITCODE -in $fzfNoMatchExitCode, $fzfCancelledExitCode) {
    return
}
if ($LASTEXITCODE -ne 0) {
    throw "fzf failed with exit code $LASTEXITCODE."
}

$failedModules = [System.Collections.Generic.List[string]]::new()
foreach ($row in $selection) {
    $moduleName = ($row -split "`t", 2)[0]
    $update = $updates | Where-Object Name -EQ $moduleName
    if (-not $PSCmdlet.ShouldProcess($moduleName, "Update $($update.InstalledVersion) to $($update.LatestVersion)")) {
        continue
    }

    try {
        Write-Information "Updating $moduleName to $($update.LatestVersion)..." -InformationAction Continue
        Update-Module -Name $moduleName -RequiredVersion $update.LatestVersion -Confirm:$false
    }
    catch {
        Write-Warning "Could not update '${moduleName}': $_"
        $failedModules.Add($moduleName)
    }
}

if ($failedModules.Count -gt 0) {
    throw "Failed to update: $($failedModules -join ', ')."
}
