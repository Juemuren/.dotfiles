param(
    [Parameter(Mandatory)]
    [string]$Destination
)

sfsu bucket list --json
| jq '[.[] | {name, source}]' > $Destination
