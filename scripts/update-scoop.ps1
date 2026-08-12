# .\scoop\scripts\Get-ScoopBuckets.ps1
# | ForEach-Object {
#     .\scoop\scripts\Get-ScoopApps.ps1 "$_" > "scoop\buckets\$_.txt"
# }

sfsu bucket list --json
| jq -r '.[].name'
| ForEach-Object {
    sfsu list --json --descending --bucket $_
    | jq -r '.[].name' > "scoop/buckets/$_.txt"
}
