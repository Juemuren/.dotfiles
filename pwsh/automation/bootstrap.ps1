#Requires -Version 5.1
<#
.SYNOPSIS
Install the latest PowerShell release available from WinGet.
#>
[CmdletBinding(SupportsShouldProcess)]
param()

if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    Write-Output 'PowerShell is already installed.'
    return
}

if (-not $PSCmdlet.ShouldProcess('Microsoft.PowerShell', 'Install with WinGet')) {
    return
}

winget install --id Microsoft.PowerShell --exact --source winget `
    --silent --accept-package-agreements --accept-source-agreements

if ($LASTEXITCODE -ne 0) {
    throw "PowerShell installation failed with exit code $LASTEXITCODE."
}
