[default]
default:
    just --list

watch:
    ./bin/dotter watch --dry-run -f

preview:
    ./bin/dotter deploy --dry-run -f

deploy:
    ./bin/dotter deploy -v -f

lint-sh:
    shellcheck scripts/*.sh

update-docs:
    ./scripts/update-docs.sh

[windows]
[script("pwsh")]
update-scoop bucket:
    ./scoop/Get-ScoopApps {{bucket}} > "scoop/{{bucket}}.txt"
