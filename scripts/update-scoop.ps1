.\scoop\scripts\Get-ScoopBuckets.ps1 |
ForEach-Object {
    .\scoop\scripts\Get-ScoopApps.ps1 "$_" > "scoop\buckets\$_.txt"
}
