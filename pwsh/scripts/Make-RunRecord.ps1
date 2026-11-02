#Requires -Version 7.0
<#
.SYNOPSIS
Runs a PowerShell command and saves the command and its output as an image.

.DESCRIPTION
Runs the command in a new PowerShell process. Saves the image even if the
command fails, then returns the command's exit code.

.EXAMPLE
Make-RunRecord.ps1 -CommandLine 'python -B script.py --input sample.json'

.EXAMPLE
Make-RunRecord.ps1 -CommandLine 'Get-Date; Write-Output "done"' -OutputPath images/record.png

.EXAMPLE
Make-RunRecord.ps1 -CommandLine 'Get-Date' -ShowExitCode -ExitCodeColor '#808080'
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0)]
    [string]$CommandLine,

    [string]$OutputPath = 'record.png',

    [ValidateRange(1, 10000)]
    [int]$Width = 1600,

    [string]$Font = 'C:/Windows/Fonts/consola.ttf',

    [string]$BackgroundColor = '#14202d',

    [string]$CommandColor = '#e8f0f7',

    [string]$ResultColor = '#8de2a2',

    [switch]$ShowExitCode,

    [string]$ExitCodeColor = '#8b98a5',

    [ValidateRange(1, 200)]
    [int]$CommandFontSize = 28,

    [ValidateRange(1, 200)]
    [int]$ResultFontSize = 31
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

$result = @(& pwsh -NoProfile -Command $CommandLine 2>&1)
$commandExitCode = $LASTEXITCODE

$commandLines = @($CommandLine -split "`r?`n")
$resultLines = @($result | ForEach-Object { [string]$_ })

$margin = 40
$commandLineHeight = $CommandFontSize + 14
$resultLineHeight = $ResultFontSize + 15
$sectionGap = 36
$commandY = $margin + $CommandFontSize
$resultY = $commandY + $commandLines.Count * $commandLineHeight + $sectionGap
if ($resultLines.Count -eq 0 -and -not $ShowExitCode) {
    $lastY = $commandY + ($commandLines.Count - 1) * $commandLineHeight
}
else {
    $lastY = $resultY + ($resultLines.Count - 1 + [int]$ShowExitCode.IsPresent) * $resultLineHeight
}
$height = $lastY + $margin

$draw = @(
    '-size', "${Width}x$height", "xc:$BackgroundColor",
    '-font', $Font,
    '-fill', $CommandColor,
    '-pointsize', $CommandFontSize
)
for ($i = 0; $i -lt $commandLines.Count; $i++) {
    $y = $commandY + $i * $commandLineHeight
    $prefix = if ($i -eq 0) { '> ' } else { "`u{2219} " }
    $draw += @('-annotate', "+$margin+$y", "$prefix$($commandLines[$i])")
}
$draw += @(
    '-fill', $ResultColor,
    '-pointsize', $ResultFontSize
)
for ($i = 0; $i -lt $resultLines.Count; $i++) {
    $y = $resultY + $i * $resultLineHeight
    $draw += @('-annotate', "+$margin+$y", $resultLines[$i])
}

if ($ShowExitCode) {
    $y = $resultY + $resultLines.Count * $resultLineHeight
    $draw += @(
        '-fill', $ExitCodeColor,
        '-annotate', "+$margin+$y",
        "exit code: $commandExitCode"
    )
}

$parent = Split-Path -Parent $OutputPath
if ($parent) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }

& magick @draw $OutputPath
if ($LASTEXITCODE -ne 0) { throw 'Image generation failed' }

Write-Output "Generated $OutputPath"
exit $commandExitCode
