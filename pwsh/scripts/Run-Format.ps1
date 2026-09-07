<#
.SYNOPSIS
Formats PowerShell scripts with PSScriptAnalyzer.

.DESCRIPTION
Writes only changed files, using LF line endings and one final newline.
Reports changed files and a batch summary. Use -Verbose to show unchanged files.

.PARAMETER Path
File paths, supplied as an array or through the pipeline.

.PARAMETER Check
Reports files needing formatting without writing changes.

.PARAMETER Quiet
Hides successful formatting output and summaries. Check findings and execution errors remain visible.

.EXAMPLE
Run-Format.ps1 .\test.ps1 -Check

.EXAMPLE
Run-Format.ps1 -Path a.ps1, b.ps1

.EXAMPLE
fd -e ps1 -e psm1 | Run-Format.ps1

.NOTES
Exit codes:
    0: formatted or unchanged
    1: -Check found changes
    2: execution failed for at least one file
Continues after file failures. Exit code 2 takes precedence over 1.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    [string[]]$Path,

    [switch]$Check,

    [switch]$Quiet
)

begin {
    function ConvertTo-FormattedScriptText {
        param([string]$Text)

        $normalized = $Text.Replace("`r`n", "`n")
        $formatted = Invoke-Formatter -ScriptDefinition $normalized -Verbose:$false
        return $formatted.TrimEnd("`r", "`n") + "`n"
    }

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
            $formatted = ConvertTo-FormattedScriptText -Text $original

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
