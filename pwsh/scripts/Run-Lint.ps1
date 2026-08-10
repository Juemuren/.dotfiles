param(
    [Parameter(Mandatory)]
    [string]$Path
)

Invoke-ScriptAnalyzer -Path $Path |
ForEach-Object {
    $path = $_.ScriptPath
    $line = $_.Line
    $column = $_.Column
    $severity = $_.Severity.ToString().ToUpperInvariant()
    $rule = $_.RuleName
    $message = $_.Message

    @"
${path}:${line}:$column
[$severity] ${rule}: $message

"@
}
