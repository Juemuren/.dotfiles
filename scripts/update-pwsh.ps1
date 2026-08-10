Get-InstalledModule |
Select-Object -ExpandProperty Name > "pwsh/modules.txt"

if (Get-Module -Name PSCompletions) {
    psc list | Select-Object -ExpandProperty Completion > "pwsh/psc.txt"
}
