param(
    [Parameter(Mandatory, Position = 0)]
    [string[]]$Path
)

$tokens = $null
$errors = $null

[System.Management.Automation.Language.Parser]::ParseFile(
    (Resolve-Path $Path),
    [ref]$tokens,
    [ref]$errors
) | Out-Null

$errors | Format-List *
