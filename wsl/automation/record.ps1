#Requires -Version 7.0
param(
    [Parameter(Mandatory)]
    [string]$Destination
)

$ErrorActionPreference = 'Stop'

# wsl --list output is unreliable when redirected.
$registryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss'
$distributions = @(
    if (Test-Path -LiteralPath $registryPath) {
        Get-ChildItem -LiteralPath $registryPath |
            ForEach-Object {
                (Get-ItemProperty -LiteralPath $_.PSPath).DistributionName
            } |
            Where-Object { $_ } |
            Sort-Object -Unique
    }
)

$content = if ($distributions.Count) { ($distributions -join "`n") + "`n" } else { '' }

[IO.File]::WriteAllText($Destination, $content, [Text.UTF8Encoding]::new($false))
