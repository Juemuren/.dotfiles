set default-list := true

[windows]
mod windows 'scripts/windows'
[unix]
mod unix 'scripts/unix'

mod common 'scripts/common'
mod vscode 'scripts/vscode'

mod checks 'scripts/checks'
mod docs 'scripts/docs'

watch:
    ./bin/dotter watch --dry-run --force

preview:
    ./bin/dotter deploy --dry-run --force

deploy:
    ./bin/dotter deploy --verbose --force --noconfirm
