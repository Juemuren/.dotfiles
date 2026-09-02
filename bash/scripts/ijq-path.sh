#!/bin/sh

ECHO="echo {r} && jq -C getpath({}) $1"

jq -r 'paths | tojson' "$1" \
    | fzf \
        --preview "$ECHO" \
        --bind "enter:become:$ECHO" \
        --preview-window wrap
