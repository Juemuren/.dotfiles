#Requires -Modules ScriptRunner

<#
.SYNOPSIS
Runs a local script through ScriptRunner and returns its exit code.

.DESCRIPTION
Pass a script name from ~/.local/bin or a script path, followed by its arguments.
Arguments are forwarded unchanged; the interpreter is selected from the shebang
or defaults to pwsh for .ps1 files.

.EXAMPLE
Run-Scripts.ps1 backup.sh --target 'D:\My Backups'
#>
Invoke-LocalScript @args
exit $LASTEXITCODE
