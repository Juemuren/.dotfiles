[System.Environment]::SetEnvironmentVariable(
    'HOME',
    "$HOME",
    [System.EnvironmentVariableTarget]::User
)

$dir = Join-Path $HOME '.local/bin'
$entries = @(
    [System.Environment]::GetEnvironmentVariable(
        'PATH',
        [System.EnvironmentVariableTarget]::User
    ) -split [IO.Path]::PathSeparator
) | Where-Object { $_ }
if ($dir -notin $entries) {
    $PATH = (@($entries) + $dir) -join [IO.Path]::PathSeparator
    [System.Environment]::SetEnvironmentVariable(
        'PATH',
        $PATH,
        [System.EnvironmentVariableTarget]::User
    )
}
