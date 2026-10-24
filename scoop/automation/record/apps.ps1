param(
    [Parameter(Mandatory)]
    [string]$Destination
)

sfsu bucket list --json
| jq -r '.[].name'
| ForEach-Object {
    sfsu list --json --descending --bucket $_
    | jq -r '.[].name' > (Join-Path $Destination "$_.txt")
}
