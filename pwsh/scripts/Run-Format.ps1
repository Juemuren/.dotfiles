param(
    [Parameter(Mandatory)]
    [string]$Path
)

$code = (Get-Content -LiteralPath $Path -Raw).Replace("`r`n", "`n")
$formatted = (Invoke-Formatter -ScriptDefinition $code).TrimEnd("`r", "`n") + "`n"
Set-Content -LiteralPath $Path -Value $formatted -NoNewline
