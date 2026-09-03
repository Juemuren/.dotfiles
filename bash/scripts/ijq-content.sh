#!/bin/sh

PRINTF="printf '%s\n\n' '# Path' {r1} '# Content' {r2}"
BAT='bat --color=always --style=plain --language=markdown'

jq -r 'paths(scalars) as $p | ($p | join("/") | tojson) + "\t" + (getpath($p) | tojson)' "$1" \
    | fzf --with-shell 'sh -c' \
        --delimiter '\t' \
        --with-nth 2 \
        --bind "enter:become:$PRINTF | $BAT --paging=never" \
        --preview "$PRINTF | $BAT" \
        --preview-window wrap
