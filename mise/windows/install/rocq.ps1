$ErrorActionPreference = 'Stop'

$p = $env:MISE_TOOL_INSTALL_PATH
$f = Get-ChildItem $p -Recurse -Filter 'signed_*.exe' | Select-Object -First 1

Start-Process $f.FullName -ArgumentList "/S /D=$p" -Wait
