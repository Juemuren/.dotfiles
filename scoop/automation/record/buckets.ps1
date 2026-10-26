#Requires -Version 7.0
param(
    [Parameter(Mandatory)]
    [string]$Destination
)

sfsu bucket list --json
| jq '[.[] | {name, source}]' > $Destination
