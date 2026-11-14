#!/bin/bash

set -eu

cd -- "$1"

. .scripts/checks/sections.sh

get_config_dirs() {
    local dir

    for dir in */; do
        if [ -f "${dir}mise.toml" ] || [ -f "${dir}mise.windows.toml" ] || [ -f "${dir}mise.linux.toml" ]; then
            printf '%s\n' "${dir%/}"
        fi
    done
}

render_groups() {
    local name

    while IFS= read -r name; do
        printf '%s\n' \
            "[dotfile_groups.$name]" \
            "root = \"$name\"" \
            "target = \"~/.config/mise/conf.d/$name\"" \
            'mode = "symlink"' \
            ''
    done
}

get_config_dirs |
    render_groups |
    update_section mise.toml TOOL
