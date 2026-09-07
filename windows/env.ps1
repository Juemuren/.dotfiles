[Environment]::SetEnvironmentVariable(
    'HOME',
    "$env:USERPROFILE",
    'User'
)

$SCOOP_HOME = (Resolve-Path "$(scoop prefix scoop)\..\..\..").Path
[System.Environment]::SetEnvironmentVariable(
    'SCOOP_HOME',
    "$SCOOP_HOME",
    'User'
)
