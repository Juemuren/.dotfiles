<#
.SYNOPSIS
Reads the file contents of an external command or script as text.

.DESCRIPTION
Requires bat.
Displays syntax-highlighted text using bat's paging and wrapping settings
Binary content is not printed.

.PARAMETER CommandName
Command name or path, including .ps1, .bat, and .cmd scripts.
Aliases are resolved to their target command. Cmdlets and functions are not supported.

.EXAMPLE
Get-CommandContent.ps1 Run-Lint.ps1

.EXAMPLE
Get-CommandContent.ps1 tlmgr
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0)]
    [string]$CommandName
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false
$command = Get-Command -Name $CommandName
if ($command -is [System.Management.Automation.AliasInfo]) {
    $command = $command.ResolvedCommand
}
if ($command.CommandType -notin 'Application', 'ExternalScript') {
    throw "'$CommandName' is not an external command or script."
}
# Keep binary detection enabled in pipelines instead of bat's raw passthrough mode.
bat --style=plain --color=always --binary=no-printing -- $command.Path
if ($LASTEXITCODE -ne 0) {
    throw "bat failed to read '$($command.Path)' with exit code $LASTEXITCODE."
}
