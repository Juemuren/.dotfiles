$ExtensionsPath = "~/.vscode/extensions"

Get-ChildItem $ExtensionsPath -Directory
| Group-Object -Property {
    if ($_.Name -match '^(.+?)-\d') {
        $matches[1]
    }
    else {
        $_.Name
    }
}
| Where-Object Count -GT 1
| ForEach-Object {
    $count = $_.Count
    $name = $_.Name
    $versions = $_.Group.Name

    "$($PSStyle.Foreground.Cyan)[$count] $name$($PSStyle.Reset)"
    $versions | ForEach-Object { "  - $_" }
    ""
}
