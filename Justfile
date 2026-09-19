set default-list := true

mod common '.scripts/common'
[windows]
mod windows '.scripts/windows'
[unix]
mod unix '.scripts/unix'

mod checks '.scripts/checks'
mod docs '.scripts/docs'

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

watch:
    ./.bin/dotter watch --dry-run --force

preview:
    ./.bin/dotter deploy --dry-run --force

deploy:
    ./.bin/dotter deploy --verbose --force --noconfirm
