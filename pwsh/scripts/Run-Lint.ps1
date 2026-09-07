<#
.SYNOPSIS
Checks PowerShell scripts with PSScriptAnalyzer.

.DESCRIPTION
Accepts a path array or paths from the pipeline.
Findings and execution errors remain visible.

Outputs ANSI colors by default. Use -NoColor or set $env:NO_COLOR to avoid coloring.
Use -Quiet to hide the summary.

Exit codes:
    - 0: no findings
    - 1: lint findings
    - 2: execution failed

.EXAMPLE
Run-Lint.ps1 .\test.ps1

.EXAMPLE
fd -e ps1 -e psm1 | Run-Lint.ps1
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    [string[]]$Path,

    [switch]$NoColor,

    [switch]$Quiet
)

begin {
    $ErrorActionPreference = 'Stop'
    $useColor = -not $NoColor -and [string]::IsNullOrEmpty($env:NO_COLOR)
    $fileCount = 0
    $findingCount = 0
    $failedCount = 0
}

process {
    foreach ($filePath in $Path) {
        $fileCount++
        try {
            $findings = @(Invoke-ScriptAnalyzer -Path $filePath)
            $findingCount += $findings.Count
            foreach ($finding in $findings) {
                $severity = $finding.Severity.ToString().ToUpperInvariant()
                if ($useColor) {
                    $severityColor = switch ($severity) {
                        'ERROR' { $PSStyle.Foreground.Red }
                        'WARNING' { $PSStyle.Foreground.Yellow }
                        'INFORMATION' { $PSStyle.Foreground.Blue }
                        'PARSEERROR' { $PSStyle.Foreground.Magenta }
                        default { $PSStyle.Reset }
                    }
                    $text = "{0}{1}:{2}:{3}{4}`n {5}[{6}] {7}{8}{4}: {9}`n" -f `
                        $PSStyle.Foreground.Cyan, `
                        $finding.ScriptPath, `
                        $finding.Line, `
                        $finding.Column, `
                        $PSStyle.Reset, `
                        $severityColor, `
                        $severity, `
                        $PSStyle.Foreground.Green, `
                        $finding.RuleName, `
                        $finding.Message
                    Write-Output $text
                }
                else {
                    $text = "{0}:{1}:{2}`n [{3}] {4}: {5}`n" -f `
                        $finding.ScriptPath, `
                        $finding.Line, `
                        $finding.Column, `
                        $severity, `
                        $finding.RuleName, `
                        $finding.Message
                    Write-Output $text
                }
            }

        }
        catch {
            $failedCount++
            [Console]::Error.WriteLine("Lint failed: ${filePath}: $($_.Exception.Message)")
        }
    }
}

end {
    if (-not $Quiet) {
        Write-Output "Lint: $fileCount files, $findingCount findings, $failedCount failed."
    }
    if ($failedCount -gt 0) {
        exit 2 # Tool or input failure takes precedence over lint findings.
    }
    if ($findingCount -gt 0) {
        exit 1 # Lint findings, including warnings.
    }
    exit 0
}
