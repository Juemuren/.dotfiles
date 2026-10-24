set default-list
mod common '.scripts/common'
[windows]
mod windows '.scripts/windows'
[unix]
mod unix '.scripts/unix'

mod checks '.scripts/checks'

[windows]
record: windows::record common::record

[unix]
record: unix::record common::record

[windows]
restore: windows::restore common::restore

[unix]
restore: unix::restore common::restore

[windows]
bootstrap: windows::bootstrap

[unix]
bootstrap: unix::bootstrap

preview:
    mise dot apply --dry-run

deploy:
    mise dot apply
