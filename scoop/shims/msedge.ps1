[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSAvoidUsingPositionalParameters',
    '',
    Justification = 'scoop uses positional CLI subcommands and arguments.'
)]
param()

scoop shim add msedge 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
