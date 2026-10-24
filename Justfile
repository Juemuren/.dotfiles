set default-list
mod common '.scripts/common'
mod vscode 'vscode'
[windows]
mod scoop 'scoop'
[windows]
mod windows '.scripts/windows'
[unix]
mod unix '.scripts/unix'

mod checks '.scripts/checks'

[windows]
record: windows::record common::record scoop::record vscode::record

[unix]
record: unix::record common::record vscode::record

[windows]
restore: windows::restore common::restore scoop::restore vscode::restore

[unix]
restore: unix::restore common::restore vscode::restore

[windows]
bootstrap: windows::bootstrap

[unix]
bootstrap: unix::bootstrap

preview:
    mise dot apply --dry-run

deploy:
    mise dot apply
