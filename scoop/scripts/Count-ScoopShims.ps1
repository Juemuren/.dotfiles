#Requires -Version 7.0
scoop shim list
| Group-Object Source
| Select-Object Name, Count
| Sort-Object Count
