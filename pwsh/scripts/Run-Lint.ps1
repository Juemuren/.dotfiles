param(
    [Parameter(Mandatory)]
    [string]$Path
)

Invoke-ScriptAnalyzer -Path $Path
| ForEach-Object {
    $path = $_.ScriptPath
    $line = $_.Line
    $column = $_.Column
    $severity = $_.Severity.ToString().ToUpperInvariant()
    $rule = $_.RuleName
    $message = $_.Message

    $severityColor = switch ($severity) {
        'ERROR' { $PSStyle.Foreground.Red }
        'WARNING' { $PSStyle.Foreground.Yellow }
        'INFORMATION' { $PSStyle.Foreground.Blue }
        'PARSEERROR' { $PSStyle.Foreground.Magenta }
        default { $PSStyle.Reset }
    }

    "$($PSStyle.Foreground.Cyan)${path}:${line}:$column"
    "$severityColor[$severity] $($PSStyle.Foreground.Green)${rule}$($PSStyle.Reset): $message"
    ""
}
