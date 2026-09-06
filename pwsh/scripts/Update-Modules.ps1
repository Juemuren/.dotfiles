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
        }
    }
)

if ($updates.Count -eq 0) {
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
# fzf 退出码：1 表示没有匹配项；130 表示用户按 Esc 或 Ctrl+C 取消。
if ($LASTEXITCODE -in 1, 130) {
    return
}
if ($LASTEXITCODE -ne 0) {
    throw "fzf failed with exit code $LASTEXITCODE."
}

$failedModules = @(
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
            $moduleName
        }
    }
)

if ($failedModules.Count -gt 0) {
    throw "Failed to update: $($failedModules -join ', ')."
}
