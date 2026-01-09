[default]
default:
    just --list

lint-sh:
    shellcheck scripts/*.sh

update-docs:
    ./scripts/update-docs.sh

[windows]
[script("pwsh")]
update-scoop bucket:
    ./scoop/Get-ScoopApps {{bucket}} > "scoop/{{bucket}}.txt"