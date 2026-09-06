#!/bin/sh

file=$1

# shellcheck disable=SC2016
JQ_GET_CONTENTS='
    paths(scalars) as $p
        | ($p | join("/") | tojson)
        + "\t"
        + (getpath($p) | tojson)
'

FORMAT="printf '%s\n\n' '# Path' {r1} '# Content' {r2}"
RENDER='bat --color=always --style=plain --language=markdown'

jq -r "$JQ_GET_CONTENTS" "$file" |
    fzf --with-shell 'sh -c' \
        --delimiter '\t' \
        --with-nth 2 \
        --bind "enter:become:$FORMAT | $RENDER --paging=never" \
        --preview "$FORMAT | $RENDER" \
        --preview-window wrap
