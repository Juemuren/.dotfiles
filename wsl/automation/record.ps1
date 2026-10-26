#Requires -Version 7.0
param(
    [Parameter(Mandatory)]
    [string]$Destination
)

$ErrorActionPreference = 'Stop'

$distributions = @(& "$PSScriptRoot/helper/registered-distributions.ps1")

$content = if ($distributions.Count) { ($distributions -join "`n") + "`n" } else { '' }

[IO.File]::WriteAllText($Destination, $content, [Text.UTF8Encoding]::new($false))
