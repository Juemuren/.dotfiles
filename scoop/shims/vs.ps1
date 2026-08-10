[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSAvoidUsingPositionalParameters',
    '',
    Justification = 'scoop uses positional CLI subcommands and arguments.'
)]
param()

scoop shim add vs '{{vs_root}}\Common7\Tools\Launch-VsDevShell.ps1' '--' -Arch amd64 -HostArch amd64 -SkipAutomaticLocation
