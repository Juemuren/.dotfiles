<#
.SYNOPSIS
Checks PowerShell syntax with the PowerShell parser.

.DESCRIPTION
Reports parse errors for each file and a batch summary.

.PARAMETER Path
File paths, supplied as an array or through the pipeline.

.PARAMETER Quiet
Hides the summary. Parse errors and execution errors remain visible.

.EXAMPLE
Run-Parse.ps1 .\test.ps1

.EXAMPLE
Run-Parse.ps1 -Path a.ps1, b.ps1

.EXAMPLE
fd -e ps1 -e psm1 -e psd1 | Run-Parse.ps1

.NOTES
Exit codes:
    0: no parse errors
    1: parse errors
    2: execution failed for at least one file
Continues after file failures. Exit code 2 takes precedence over 1.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    [string[]]$Path,

    [switch]$Quiet
)

begin {
    $ErrorActionPreference = 'Stop'
    $fileCount = 0
    $parseErrorCount = 0
    $failedCount = 0
}

process {
    foreach ($filePath in $Path) {
        $fileCount++
        try {
            $resolvedPath = (Resolve-Path -LiteralPath $filePath).ProviderPath
            $tokens = $null
            $parseErrors = $null
            $null = [System.Management.Automation.Language.Parser]::ParseFile(
                $resolvedPath,
                [ref]$tokens,
                [ref]$parseErrors
            )

            # ParseFile reports file read failures as ParseError objects, too.
            $readErrors = @($parseErrors | Where-Object ErrorId -EQ 'FileReadError')
            if ($readErrors.Count -gt 0) {
                $failedCount++
                foreach ($readError in $readErrors) {
                    [Console]::Error.WriteLine("Parse failed: ${filePath}: $($readError.Message)")
                }
                continue
            }

            $parseErrorCount += $parseErrors.Count
            foreach ($parseError in $parseErrors) {
                Write-Output ("{0}:{1}:{2}`n[PARSEERROR] {3}: {4}" -f
                    $resolvedPath, $parseError.Extent.StartLineNumber,
                    $parseError.Extent.StartColumnNumber, $parseError.ErrorId,
                    $parseError.Message)
            }
        }
        catch {
            $failedCount++
            [Console]::Error.WriteLine("Parse failed: ${filePath}: $($_.Exception.Message)")
        }
    }
}

end {
    if (-not $Quiet) {
        Write-Output "Parse: $fileCount files, $parseErrorCount errors, $failedCount failed."
    }
    if ($failedCount -gt 0) {
        exit 2 # Tool or input failure takes precedence over parse errors.
    }
    if ($parseErrorCount -gt 0) {
        exit 1 # Syntax errors were found.
    }
    exit 0
}
