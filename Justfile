[default]
default:
    just --list

lint-sh:
    shellcheck scripts/*.sh

update-docs:
    ./scripts/update-docs.sh