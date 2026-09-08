set default-list := true

[windows]
mod windows 'scripts/windows'
[unix]
mod unix 'scripts/unix'

mod common 'scripts/common'
mod pwsh 'scripts/pwsh'
mod sh 'scripts/sh'
mod py 'scripts/py'
mod vscode 'scripts/vscode'
mod docs 'scripts/docs'

watch:
    ./bin/dotter watch --dry-run --force

preview:
    ./bin/dotter deploy --dry-run --force

deploy:
    ./bin/dotter deploy --verbose --force --noconfirm

fmt: pwsh::fmt sh::fmt py::fmt
    dprint fmt

lint: pwsh::lint sh::lint py::lint
