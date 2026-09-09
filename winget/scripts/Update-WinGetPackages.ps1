#Requires -Version 7.0
#Requires -Modules Microsoft.WinGet.Client
<#
.SYNOPSIS
Select available WinGet updates with fzf and upgrade the selected packages.

.DESCRIPTION
Requires winget, fzf, and the Microsoft.WinGet.Client PowerShell module.
Install the module with: Install-Module Microsoft.WinGet.Client -Scope CurrentUser
Tab toggles selection, Ctrl+A selects all, Enter upgrades, and Esc cancels.
Uses structured package objects so localized or truncated CLI tables are not parsed.

.EXAMPLE
Update-WinGetPackages.ps1

.EXAMPLE
Update-WinGetPackages.ps1 -WhatIf
#>
[CmdletBinding(SupportsShouldProcess)]
param()

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

Write-Information 'Checking for WinGet updates...' -InformationAction Continue
$updates = @(Get-WinGetPackage | Where-Object IsUpdateAvailable | Sort-Object Name, Id, Source)
if ($updates.Count -eq 0) {
    Write-Output 'No updates found.'
    return
}

$selection = @(
    for ($index = 0; $index -lt $updates.Count; $index++) {
        $package = $updates[$index]
        # The hidden index maps each row to its original package, including its source.
        "$index`t$($package.Name)`t$($package.Id)`t$($package.InstalledVersion)`t$($package.Source)"
    }
) | fzf --multi --delimiter="`t" --with-nth=2.. `
    --height=60% `
    --layout=reverse `
    --prompt='update> ' `
    --header='Name / ID / Installed / Source | Tab: select | Ctrl+A: all | Enter: update | Esc: cancel' `
    --bind='ctrl-a:select-all'

$fzfNoMatchExitCode = 1
$fzfCancelledExitCode = 130
if ($LASTEXITCODE -in $fzfNoMatchExitCode, $fzfCancelledExitCode) {
    return
}
if ($LASTEXITCODE -ne 0) {
    throw "fzf failed with exit code $LASTEXITCODE."
}

$failedPackages = @(
    foreach ($row in $selection) {
        $index = [int]($row -split "`t", 2)[0]
        $package = $updates[$index]
        $target = "$($package.Id) ($($package.Source))"
        if (-not $PSCmdlet.ShouldProcess($target, "Upgrade from $($package.InstalledVersion)")) {
            continue
        }

        try {
            Write-Information "Updating $target..." -InformationAction Continue
            $arguments = @('upgrade', '--id', $package.Id, '--exact')
            if ($package.Source) {
                $arguments += '--source', $package.Source
            }
            # Keep installer output visible without adding it to the failure list.
            winget @arguments | Out-Host
            if ($LASTEXITCODE -ne 0) {
                throw "winget exited with code $LASTEXITCODE."
            }
        }
        catch {
            Write-Warning "Could not update '${target}': $_"
            $target
        }
    }
)

if ($failedPackages.Count -gt 0) {
    throw "Failed to update: $($failedPackages -join ', ')."
}
