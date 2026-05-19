[default]
default:
    just --list

[linux]
install:
    wget https://github.com/SuperCuber/dotter/releases/latest/download/dotter-linux-x64-musl
    chmod +x dotter-linux-x64-musl
    mkdir bin
    mv dotter-linux-x64-musl ./bin/dotter

watch:
    ./bin/dotter watch --dry-run -f

preview:
    ./bin/dotter deploy --dry-run -f

deploy:
    ./bin/dotter deploy -v -f

[windows]
[script("pwsh")]
update-scoop:
    ./scoop/Get-ScoopBuckets | ForEach-Object { ./scoop/Get-ScoopApps "$_" > "scoop/$_.txt" }

lint-sh:
    shellcheck scripts/*.sh

update-docs:
    ./scripts/update-docs.sh
