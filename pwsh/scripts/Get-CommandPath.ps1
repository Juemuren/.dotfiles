<#
.SYNOPSIS
Returns the file path of an external command or PowerShell script.

.PARAMETER CommandName
Command name or path. Aliases are resolved to their target command.
Cmdlets and functions have no command file path and are rejected.

.EXAMPLE
Get-CommandPath.ps1 pwsh
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0)]
    [string]$CommandName
)

$ErrorActionPreference = 'Stop'
$command = Get-Command -Name $CommandName
if ($command -is [System.Management.Automation.AliasInfo]) {
    $command = $command.ResolvedCommand
}
if ($command.CommandType -notin 'Application', 'ExternalScript') {
    throw "'$CommandName' is not an external command or script."
}
$command.Path
