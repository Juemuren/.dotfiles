param(
    [Parameter(Mandatory=$true)]
    [string]$ScriptPath,

    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Arguments
)

$ScriptPath = '~/.local/bin/' + $ScriptPath
$ShellPath = 'sh'

if ($IsWindows) {
    Write-Host "Command: $ShellPath $ScriptPath $Arguments"
    & $ShellPath $ScriptPath $Arguments
}
else {
    bash $ScriptPath $Arguments
}
