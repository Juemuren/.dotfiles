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

    fd -d 1 -t dir --search-path "$path" --format '* [{/.}]({})'
}

get_dirs . |
    update_section README.md TOOL

get_dirs vscode/profiles |
    update_section README.md VSCODE-PROFILE

get_dirs agents/skills |
    update_section README.md AGENT-SKILL

get_dirs pwsh/modules |
    update_section README.md PWSH-MODULE
