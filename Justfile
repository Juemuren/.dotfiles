set default-list := true

[unix]
set script-interpreter := ["sh", "-eu"]

[windows]
set script-interpreter := ["pwsh", "-NoProfile", "-File"]

[windows]
mod windows 'windows.just'
[unix]
mod unix 'unix.just'

mod pwsh 'pwsh.just'
mod sh 'sh.just'
mod py 'py.just'

watch:
    ./bin/dotter watch --dry-run --force

preview:
    ./bin/dotter deploy --dry-run --force

deploy:
    ./bin/dotter deploy --verbose --force --noconfirm

[script]
update-tex:
    tlmgr info --list --only-installed --data name > "tex/{{ os() }}/packages.txt"

update-vscode profile:
    ./scripts/update-vscode.sh "{{ profile }}"

fmt:
    dprint fmt

lint: pwsh::lint sh::lint py::lint

update-docs:
    ./scripts/update-docs.sh
