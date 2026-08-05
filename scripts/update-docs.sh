#!/bin/bash

update_section() {
    local file=$1
    local marker=$2
    local content=$3

    sd -A -f s \
        "<!-- $marker:START -->.*<!-- $marker:END -->" \
        "<!-- $marker:START -->\n$content\n<!-- $marker:END -->" \
        "$file"
}

get_dirs() {
    local path=$1
    local exclude=${2:-}

    if [[ -z "$exclude" ]]; then
        fd -d 1 -t dir --search-path "$path" --format '* {/.}'
    else
        fd -d 1 -t dir --search-path "$path" --exclude "$exclude" --format '* {/.}'
    fi
}

TOOL_LIST="$(get_dirs . scripts)"
update_section README.md TOOL-LIST "$TOOL_LIST"

VSCODE_PROFILE_LIST="$(get_dirs vscode/profiles)"
update_section README.md VSCODE-PROFILE-LIST "$VSCODE_PROFILE_LIST"

CODEX_SKILL_LIST="$(get_dirs codex/skills)"
update_section README.md CODEX-SKILL-LIST "$CODEX_SKILL_LIST"

