param([string]$ScriptPath)

Import-Module ScriptRunner
Invoke-LocalScript $ScriptPath @args
exit $LASTEXITCODE
