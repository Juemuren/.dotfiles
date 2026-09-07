<#
.SYNOPSIS
Formats PowerShell scripts with PSScriptAnalyzer.

.DESCRIPTION
Accepts a path array or paths from the pipeline.
Uses LF line endings and one final newline.
Writes only changed files.

Use -Check to report whether formatting is needed without writing.
Use -Verbose to show unchanged files.
Use -Quiet to hide successful formatting output and summaries; check failures remain visible.

Exit codes:
    - 0: formatted or unchanged
    - 1: -Check found changes
    - 2: execution failed.

.EXAMPLE
Run-Format.ps1 .\test.ps1 -Check

.EXAMPLE
fd -e ps1 -e psm1 | Run-Format.ps1
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    [string[]]$Path,

    [switch]$Check,

    [switch]$Quiet
)

begin {
    $ErrorActionPreference = 'Stop'
    $fileCount = 0
    $changedCount = 0
    $unchangedCount = 0
    $failedCount = 0
}

process {
    foreach ($filePath in $Path) {
        $fileCount++
        try {
            $original = (Get-Content -LiteralPath $filePath -Raw) ?? ''
            $formatted = (Invoke-Formatter -ScriptDefinition $original.Replace("`r`n", "`n") -Verbose:$false).TrimEnd("`r", "`n") + "`n"

            if ($original -ceq $formatted) {
                $unchangedCount++
                Write-Verbose "Unchanged: $filePath"
                continue
            }
            if ($Check) {
                $changedCount++
                Write-Output "Needs formatting: $filePath"
                continue
            }

            Set-Content -LiteralPath $filePath -Value $formatted -NoNewline
            $changedCount++
            if (-not $Quiet) {
                Write-Output "Formatted: $filePath"
            }
        }
        catch {
            $failedCount++
            [Console]::Error.WriteLine("Format failed: ${filePath}: $($_.Exception.Message)")
        }
    }
}

end {
    if (-not $Quiet) {
        $changeLabel = if ($Check) { 'need formatting' } else { 'changed' }
        Write-Output "Format: $fileCount files, $changedCount $changeLabel, $unchangedCount unchanged, $failedCount failed."
    }
    if ($failedCount -gt 0) {
        exit 2 # Tool or input failure takes precedence over check findings.
    }
    if ($Check -and $changedCount -gt 0) {
        exit 1 # Check found formatting changes; the files were not written.
    }
    exit 0
}
