[unix]
set script-interpreter := ["sh", "-eu"]

[windows]
set script-interpreter := ["pwsh", "-NoProfile", "-File"]

[default]
default:
    just --list

[linux]
install:
    ./scripts/install.sh

[script("pwsh")]
[windows]
install:
    ./scripts/install.ps1

watch:
    ./bin/dotter watch --dry-run --force

preview:
    ./bin/dotter deploy --dry-run --force

deploy:
    ./bin/dotter deploy --verbose --force --noconfirm

[script("pwsh")]
[windows]
update-scoop:
    ./scripts/update-scoop.ps1

[linux]
update-brew:
    brew list --installed-on-request > "brew/{{ os() }}.txt"

[script("msys2")]
[windows]
update-pacman:
    pacman -Qeq > "pacman/msys.txt"

[script]
update-tex:
    tlmgr info --list --only-installed --data name > "tex/{{ os() }}/packages.txt"

[script("pwsh")]
update-pwsh:
    ./scripts/update-pwsh.ps1

update-vscode profile:
    ./scripts/update-vscode.sh "{{ profile }}"

format:
    dprint fmt

lint-sh:
    fd -e sh -e bash -e zsh -x shellcheck

fmt-sh:
    shfmt --write .

lint-py:
    ruff check .
    ty check .

fmt-py:
    ruff format .

[script("pwsh")]
lint-pwsh:
    fd -e ps1 -e psm1 -e psd1 | ./pwsh/scripts/Run-Lint.ps1

[script("pwsh")]
fmt-pwsh:
    fd -e ps1 -e psm1 -e psd1 | ./pwsh/scripts/Run-Format.ps1

update-docs:
    ./scripts/update-docs.sh
