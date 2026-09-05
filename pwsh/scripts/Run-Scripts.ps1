# Keep target options unbound so flags such as -Verbose pass through.
param([string]$ScriptPath)

Import-Module ScriptRunner
Invoke-LocalScript $ScriptPath @args
exit $LASTEXITCODE
