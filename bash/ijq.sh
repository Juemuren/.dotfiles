#!/bin/sh

JQ="jq -C getpath({}) $1"

jq -r 'paths | @json' "$1" |
fzf \
    --preview "$JQ" \
    --bind "enter:become:echo {r} && $JQ" \
    --preview-window wrap
