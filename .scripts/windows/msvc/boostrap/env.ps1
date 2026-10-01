$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio/Installer/vswhere.exe'
$VS_ROOT = & $vswhere -latest -products '*' -property installationPath
[System.Environment]::SetEnvironmentVariable(
    'VS_ROOT',
    "$VS_ROOT",
    [System.EnvironmentVariableTarget]::User
)
