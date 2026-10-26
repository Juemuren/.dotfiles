#Requires -Version 7.0
param(
    [Parameter(Mandatory = $true)]
    [string]$BucketName
)

scoop list 6>$null
| Where-Object Source -EQ $BucketName
| Select-Object -ExpandProperty Name
