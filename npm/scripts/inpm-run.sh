#!/bin/sh

SCRIPTS='.scripts // {} | to_entries[] | .key + "\t" + .value + "\u0000"'

PREVIEW="printf '%s\n' {2..} | bat --color=always --style=plain --language=sh --paging=never"

jq -j "$SCRIPTS" package.json |
    fzf --read0 \
        --delimiter '\t' \
        --with-nth 1 \
        --no-multi \
        --exit-0 \
        --with-shell 'sh -c' \
        --prompt 'npm run > ' \
        --header 'Enter: run | Esc: cancel' \
        --preview "$PREVIEW" \
        --preview-window wrap \
        --bind 'enter:become(npm run -- {1})'
