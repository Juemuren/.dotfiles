Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Import-Module PSCompletions
(&mise activate pwsh) | Out-String | Invoke-Expression
Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })
# fastfetch
