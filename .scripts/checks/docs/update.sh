#!/bin/bash

set -euo pipefail

cd -- "$1"

. .scripts/checks/sections.sh

get_dirs() {
    local path=$1
    local dir

    for dir in "$path"/*/; do
        [ -d "$dir" ] || continue
        dir=${dir%/}
        dir=${dir#./}
        printf '* [%s](%s)\n' "${dir##*/}" "$dir"
    done
}

get_var_dirs() {
    local config

    for config in */mise.toml; do
        if rg -q '^\[vars\]$' "$config"; then
            printf -- '- %s\n' "${config%%/*}"
        fi
    done
}

get_mapping_dirs() {
    local justfile

    for justfile in */mod.just; do
        if rg -q '^generate-path-mappings:' "$justfile"; then
            printf -- '- %s\n' "${justfile%%/*}"
        fi
    done
}

get_dirs . |
    update_section README.md TOOL

get_dirs vscode/profiles |
    update_section README.md VSCODE-PROFILE

get_dirs agents/skills |
    update_section README.md AGENT-SKILL

get_dirs pwsh/modules |
    update_section README.md PWSH-MODULE

get_var_dirs |
    update_section README.md MACHINE-VARS

get_mapping_dirs |
    update_section README.md PATH-MAPPINGS
