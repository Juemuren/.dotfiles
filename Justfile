[default]
default:
    just --list

watch:
    dotter watch --dry-run -f

preview:
    dotter deploy --dry-run -f

deploy:
    dotter deploy -v -f

lint-sh:
    shellcheck scripts/*.sh

update-docs:
    ./scripts/update-docs.sh

[windows]
[script("pwsh")]
update-scoop bucket:
    ./scoop/Get-ScoopApps {{bucket}} > "scoop/{{bucket}}.txt"