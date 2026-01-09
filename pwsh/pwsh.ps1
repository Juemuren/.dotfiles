Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Import-Module PSCompletions
$env:PYTHONIOENCODING="utf-8"
thefuck --alias | Out-String | Invoke-Expression
mise activate pwsh | Out-String | Invoke-Expression
starship init powershell | Out-String | Invoke-Expression
zoxide init powershell | Out-String | Invoke-Expression
# fastfetch
