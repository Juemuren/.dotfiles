[System.Environment]::SetEnvironmentVariable(
    'HOME',
    "$env:USERPROFILE",
    'User'
)

$SCOOP_HOME = Resolve-Path $(scoop prefix scoop)
[System.Environment]::SetEnvironmentVariable(
    'SCOOP_HOME',
    "$SCOOP_HOME",
    'User'
)

$SCOOP_ROOT = Resolve-Path "$(scoop prefix scoop)\..\..\.."
[System.Environment]::SetEnvironmentVariable(
    'SCOOP_ROOT',
    "$SCOOP_ROOT",
    'User'
)

$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio/Installer/vswhere.exe'
$VS_ROOT = & $vswhere -property installationPath
[System.Environment]::SetEnvironmentVariable(
    'VS_ROOT',
    "$VS_ROOT",
    'User'
)
