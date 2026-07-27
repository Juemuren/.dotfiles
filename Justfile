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
    ./bin/dotter watch --dry-run -f

preview:
    ./bin/dotter deploy --dry-run -f

deploy:
    ./bin/dotter deploy -v -f

[script("pwsh")]
[windows]
update-scoop:
    ./scripts/update-scoop.ps1

[linux]
update-brew os:
    brew list --installed-on-request > "brew/{{ os }}.txt"

update-pacman os:
    pacman -Qeq > "pacman/{{ os }}.txt"

update-vscode profile:
    ./scripts/update-vscode.sh "{{ profile }}"

format:
    dprint fmt

lint-sh:
    fd -e sh -e bash -e zsh -x \
        shellcheck

fmt-sh:
    fd -e sh -e bash -e zsh -x \
        shfmt --indent 4 --space-redirects --binary-next-line --write

update-docs:
    ./scripts/update-docs.sh
