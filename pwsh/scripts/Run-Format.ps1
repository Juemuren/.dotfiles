<#
.SYNOPSIS
Formats a PowerShell script with PSScriptAnalyzer.

.DESCRIPTION
Uses LF line endings and one final newline. Writes only changed files.

Use -Check to report whether formatting is needed without writing.

Exit codes:
    - 0: formatted or unchanged
    - 1: -Check found changes
    - 2: execution failed.

.EXAMPLE
Run-Format.ps1 .\test.ps1 -Check
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$Path,

    [switch]$Check
)

$ErrorActionPreference = 'Stop'

try {
    $original = (Get-Content -LiteralPath $Path -Raw) ?? ''
    $formatted = (Invoke-Formatter -ScriptDefinition $original.Replace("`r`n", "`n")).TrimEnd("`r", "`n") + "`n"

    if ($original -ceq $formatted) {
        Write-Output "Unchanged: $Path"
        exit 0
    }
    if ($Check) {
        Write-Output "Needs formatting: $Path"
        exit 1 # Check found formatting changes; the file was not written.
    }

    Set-Content -LiteralPath $Path -Value $formatted -NoNewline
    Write-Output "Formatted: $Path"
    exit 0
}
catch {
    [Console]::Error.WriteLine("Format failed: $($_.Exception.Message)")
    exit 2 # Tool or input failure.
}
