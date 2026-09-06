[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param()

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

$candidates = @(
    Get-InstalledModule | Sort-Object Name | ForEach-Object {
        $versions = @(
            Get-InstalledModule -Name $_.Name -AllVersions
            | Sort-Object Version -Descending
        )
        if ($versions.Count -gt 1) {
            [PSCustomObject]@{
                Name        = $_.Name
                KeepVersion = $versions[0].Version
                OldVersions = ($versions | Select-Object -Skip 1).Version -join ', '
            }
        }
    }
)

if ($candidates.Count -eq 0) {
    Write-Output 'No old module versions found.'
    return
}

$selection = @(
    $candidates | ForEach-Object {
        "$($_.Name)`tKeep: $($_.KeepVersion)`tRemove: $($_.OldVersions)"
    } | fzf --multi --delimiter="`t" `
        --height=60% `
        --layout=reverse `
        --prompt='clean> ' `
        --header='Tab: select | Ctrl+A: select all | Enter: clean | Esc: cancel' `
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
    $candidate = $candidates | Where-Object Name -EQ $moduleName
    if (-not $PSCmdlet.ShouldProcess($moduleName, "Remove versions $($candidate.OldVersions); keep $($candidate.KeepVersion)")) {
        continue
    }

    try {
        & "$PSScriptRoot/Clean-Module.ps1" -ModuleName $moduleName -Confirm:$false
    }
    catch {
        Write-Warning "Could not clean '${moduleName}': $_"
        $failedModules.Add($moduleName)
    }
}

if ($failedModules.Count -gt 0) {
    throw "Failed to clean: $($failedModules -join ', ')."
}
