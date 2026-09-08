set default-list := true

[unix]
set script-interpreter := ["sh", "-eu"]

[windows]
set script-interpreter := ["pwsh", "-NoProfile", "-File"]

[windows]
mod windows 'scripts/windows'
[unix]
mod unix 'scripts/unix'

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

[script]
update-tex:
    tlmgr info --list --only-installed --data name > "tex/{{ os() }}/packages.txt"

fmt: pwsh::fmt sh::fmt py::fmt
    dprint fmt

lint: pwsh::lint sh::lint py::lint
