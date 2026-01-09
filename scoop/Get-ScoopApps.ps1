param(
    [Parameter(Mandatory=$true)]
    [string]$BucketName
)

scoop list |
Where-Object Source -EQ $BucketName |
Select-Object -ExpandProperty Name
