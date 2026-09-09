#Requires -Modules PSReadLine

<#
.SYNOPSIS
Reads the history file configured in PSReadLine for the current session.

.EXAMPLE
Get-HistoryFile.ps1
#>
[CmdletBinding()]
param()

Get-Content -LiteralPath (Get-PSReadLineOption).HistorySavePath -ErrorAction Stop
