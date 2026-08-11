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
update-brew os:
    brew list --installed-on-request > "brew/{{ os }}.txt"

[script("msys2")]
[windows]
update-pacman:
    pacman -Qeq > "pacman/msys.txt"

[script("pwsh")]
[windows]
update-tex:
    tlmgr info --list --only-installed --data name > "tex/windows.txt"

[script("pwsh")]
[windows]
update-pwsh:
    ./scripts/update-pwsh.ps1

update-vscode profile:
    ./scripts/update-vscode.sh "{{ profile }}"

format:
    dprint fmt

lint-sh:
    fd -e sh -e bash -e zsh -x \
        shellcheck

fmt-sh:
    shfmt --write .

[script("pwsh")]
[windows]
lint-pwsh:
    fd -e ps1 | foreach { ./pwsh/scripts/Run-Lint.ps1 $_ }

[script("pwsh")]
[windows]
fmt-pwsh:
    fd -e ps1 | foreach { ./pwsh/scripts/Run-Format.ps1 $_ }

update-docs:
    ./scripts/update-docs.sh
