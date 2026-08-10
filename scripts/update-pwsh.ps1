Get-InstalledModule
| Select-Object -ExpandProperty Name > "pwsh/modules.txt"

if (Get-Module -Name PSCompletions) {
    PSCompletions list
    | Select-Object -ExpandProperty Completion > "pwsh/psc.txt"
}
