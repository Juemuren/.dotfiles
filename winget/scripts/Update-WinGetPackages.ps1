#Requires -Version 7.0
#Requires -Modules Microsoft.WinGet.Client
<#
.SYNOPSIS
Select available WinGet updates with fzf and upgrade the selected packages.

.DESCRIPTION
Requires winget, fzf, bat, and the Microsoft.WinGet.Client PowerShell module.
Install the module with: Install-Module Microsoft.WinGet.Client -Scope CurrentUser
Tab toggles selection, Ctrl+A selects all, Enter upgrades, and Esc cancels.
Searches package names; previews Markdown through bat without temporary files.

.EXAMPLE
Update-WinGetPackages.ps1

.EXAMPLE
Update-WinGetPackages.ps1 -WhatIf
#>
[CmdletBinding(SupportsShouldProcess)]
param()

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

function Format-PackageChoice {
    param($Package, [int]$Index)

    $markdown = @"
# $($Package.Name)

- **ID:** $($Package.Id)
- **Installed:** $($Package.InstalledVersion)
- **Source:** $($Package.Source)
"@
    # Encode multiline details so they remain one field and never become shell code.
    $details = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($markdown))
    "$Index`t$($Package.Name)`t$details"
}

Write-Information 'Checking for WinGet updates...' -InformationAction Continue
$updates = @(Get-WinGetPackage | Where-Object IsUpdateAvailable | Sort-Object Name, Id, Source)
if ($updates.Count -eq 0) {
    Write-Output 'No updates found.'
    return
}

$rows = @(
    for ($index = 0; $index -lt $updates.Count; $index++) {
        Format-PackageChoice -Package $updates[$index] -Index $index
    }
)
$preview = '[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String({3})) | bat --language=markdown --style=plain --color=always --paging=never -'
# Search names, preview details, and return only package indices.
$selection = $rows | fzf --multi --delimiter="`t" --with-nth=2 --accept-nth=1 `
    --height=60% `
    --layout=reverse `
    --prompt='update> ' `
    --header='Tab: select | Ctrl+A: all | Enter: update | Esc: cancel' `
    --with-shell='pwsh -NoLogo -NoProfile -Command' `
    --preview=$preview `
    --preview-window='right,50%,wrap' `
    --bind='ctrl-a:select-all'
if ($LASTEXITCODE -in 1, 130) {
    # fzf: no match or cancelled.
    return
}
if ($LASTEXITCODE -ne 0) {
    throw "fzf failed with exit code $LASTEXITCODE."
}

$failedPackages = [System.Collections.Generic.List[string]]::new()
foreach ($index in $selection) {
    $package = $updates[[int]$index]
    $target = "$($package.Id) ($($package.Source))"
    if (-not $PSCmdlet.ShouldProcess($target, "Upgrade from $($package.InstalledVersion)")) {
        continue
    }

    Write-Information "Updating $target..." -InformationAction Continue
    $arguments = @('upgrade', '--id', $package.Id, '--exact')
    if ($package.Source) {
        $arguments += '--source', $package.Source
    }
    winget @arguments
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Could not update '${target}': winget exited with code $LASTEXITCODE."
        $failedPackages.Add($target)
    }
}

if ($failedPackages.Count -gt 0) {
    throw "Failed to update: $($failedPackages -join ', ')."
}
