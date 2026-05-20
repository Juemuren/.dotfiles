[default]
default:
    just --list

[linux]
install:
    wget https://github.com/SuperCuber/dotter/releases/latest/download/dotter-linux-x64-musl
    chmod +x dotter-linux-x64-musl
    mkdir -p bin
    mv dotter-linux-x64-musl ./bin/dotter

[windows]
install:
    wget https://github.com/SuperCuber/dotter/releases/latest/download/dotter-windows-x64-msvc.exe
    mkdir -p bin
    mv dotter-windows-x64-msvc.exe ./bin/dotter.exe

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

[linux]
update-brew os:
    brew list --installed-on-request > "brew/{{os}}.txt"

lint-sh:
    shellcheck scripts/*.sh

update-docs:
    ./scripts/update-docs.sh
