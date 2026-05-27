./scoop/scripts/Get-ScoopBuckets |
ForEach-Object {
    ./scoop/scripts/Get-ScoopApps "$_" > "scoop/buckets/$_.txt"
}
