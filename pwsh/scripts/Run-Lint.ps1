<#
.SYNOPSIS
Checks PowerShell scripts with PSScriptAnalyzer.

.DESCRIPTION
Reports findings for each file and a batch summary.

.PARAMETER Path
File paths, supplied as an array or through the pipeline.

.PARAMETER NoColor
Disables ANSI colors. Setting the NO_COLOR environment variable also disables colors.

.PARAMETER Quiet
Hides the summary. Findings and execution errors remain visible.

.EXAMPLE
Run-Lint.ps1 .\test.ps1

.EXAMPLE
Run-Lint.ps1 -Path a.ps1, b.ps1

.EXAMPLE
fd -e ps1 -e psm1 | Run-Lint.ps1

.NOTES
Exit codes:
    0: no findings
    1: lint findings (including warnings)
    2: execution failed for at least one file
Continues after file failures. Exit code 2 takes precedence over 1.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    [string[]]$Path,

    [switch]$NoColor,

    [switch]$Quiet
)

begin {
    function Format-LintFinding {
        param(
            [object]$Finding,
            [bool]$UseColor
        )

        $severity = $Finding.Severity.ToString().ToUpperInvariant()
        $location = "{0}:{1}:{2}" -f $Finding.ScriptPath, $Finding.Line, $Finding.Column
        $rule = $Finding.RuleName
        if ($UseColor) {
            $severityColor = switch ($severity) {
                'ERROR' { $PSStyle.Foreground.Red }
                'WARNING' { $PSStyle.Foreground.Yellow }
                'INFORMATION' { $PSStyle.Foreground.Blue }
                'PARSEERROR' { $PSStyle.Foreground.Magenta }
                default { $PSStyle.Reset }
            }
            $location = "$($PSStyle.Foreground.Cyan)$location$($PSStyle.Reset)"
            $severity = "$severityColor[$severity]"
            $rule = "$($PSStyle.Foreground.Green)$rule$($PSStyle.Reset)"
        }
        else {
            $severity = "[$severity]"
        }

        return "{0}`n {1} {2}: {3}`n" -f $location, $severity, $rule, $Finding.Message
    }

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
                Format-LintFinding -Finding $finding -UseColor $useColor
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
