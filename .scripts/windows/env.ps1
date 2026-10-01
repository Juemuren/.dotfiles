$target = [System.EnvironmentVariableTarget]::User

[System.Environment]::SetEnvironmentVariable(
    'HOME',
    "$HOME",
    $target
)

$dir = Join-Path $HOME '.local/bin'
$entries = @(
    [System.Environment]::GetEnvironmentVariable('PATH', $target) -split [IO.Path]::PathSeparator
) | Where-Object { $_ }
if ($dir -notin $entries) {
    $PATH = (@($entries) + $dir) -join [IO.Path]::PathSeparator
    [System.Environment]::SetEnvironmentVariable(
        'PATH',
        $PATH,
        $target
    )
}

$SCOOP_HOME = Resolve-Path $(scoop prefix scoop)
[System.Environment]::SetEnvironmentVariable(
    'SCOOP_HOME',
    "$SCOOP_HOME",
    $target
)

$SCOOP_ROOT = Resolve-Path "$(scoop prefix scoop)\..\..\.."
[System.Environment]::SetEnvironmentVariable(
    'SCOOP_ROOT',
    "$SCOOP_ROOT",
    $target
)

$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio/Installer/vswhere.exe'
$VS_ROOT = & $vswhere -latest -products '*' -property installationPath
[System.Environment]::SetEnvironmentVariable(
    'VS_ROOT',
    "$VS_ROOT",
    $target
)
