#Requires -Version 7.0
scoop shim list
| Where-Object isHidden -EQ $true
