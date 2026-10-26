#Requires -Version 7.0
scoop bucket list
| Select-Object -ExpandProperty Name
