$SCOOP_HOME = Resolve-Path $(scoop prefix scoop)
[System.Environment]::SetEnvironmentVariable(
    'SCOOP_HOME',
    "$SCOOP_HOME",
    [System.EnvironmentVariableTarget]::User
)

$SCOOP_ROOT = Resolve-Path "$(scoop prefix scoop)\..\..\.."
[System.Environment]::SetEnvironmentVariable(
    'SCOOP_ROOT',
    "$SCOOP_ROOT",
    [System.EnvironmentVariableTarget]::User
)
