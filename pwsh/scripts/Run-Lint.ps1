<#
.SYNOPSIS
Checks a PowerShell script with PSScriptAnalyzer.

.DESCRIPTION
Outputs ANSI colors by default. Use -NoColor or set $env:NO_COLOR to avoid coloring.

Exit codes:
    - 0: no findings
    - 1: lint findings
    - 2: execution failed

.EXAMPLE
Run-Lint.ps1 .\test.ps1
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$Path,

    [switch]$NoColor
)

$ErrorActionPreference = 'Stop'
$useColor = -not $NoColor -and [string]::IsNullOrEmpty($env:NO_COLOR)

try {
    $findings = @(Invoke-ScriptAnalyzer -Path $Path)
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

    Write-Output "Lint: $($findings.Count) findings."
    if ($findings.Count -gt 0) {
        exit 1 # Lint findings, including warnings.
    }
    exit 0
}
catch {
    [Console]::Error.WriteLine("Lint failed: $($_.Exception.Message)")
    exit 2 # Tool or input failure.
}
