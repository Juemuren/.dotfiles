$extensionsPath = "~/.vscode/extensions"

Get-ChildItem $extensionsPath -Directory |
Group-Object -Property {
    if ($_.Name -match '^(.+?)-\d') {
        $matches[1]
    } else {
        $_.Name
    }
} |
Where-Object Count -gt 1 |
ForEach-Object {
    Write-Host "[$($_.Count)] $($_.Name)" -ForegroundColor Cyan
    $_.Group.Name | ForEach-Object { "  - $_" }
    ""
}
