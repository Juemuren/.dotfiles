[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSAvoidUsingPositionalParameters',
    '',
    Justification = 'scoop uses positional CLI subcommands and arguments.'
)]
param()

scoop shim add msedge 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
scoop shim add vs "$env:VS_ROOT\Common7\Tools\Launch-VsDevShell.ps1" '--' -Arch amd64 -HostArch amd64 -SkipAutomaticLocation
