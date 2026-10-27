#!/bin/bash

set -euo pipefail

cd -- "$1"

update_section() {
    local file=$1
    local marker=$2
    local content
    content=$(cat)

    sd -A -f s \
        "<!-- $marker:BEGIN -->.*<!-- $marker:END -->" \
        "<!-- $marker:BEGIN -->\n$content\n<!-- $marker:END -->" \
        "$file"
}

get_dirs() {
    local path=$1

    fd -d 1 -t dir --search-path "$path" --format '* [{/.}]({.})'
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
