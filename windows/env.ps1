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
