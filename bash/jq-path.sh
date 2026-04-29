#!/bin/sh

# 将 JSON 按路径展开作为索引

ECHO="echo {r} && jq -C getpath({}) $1"

jq -r 'paths | tojson' "$1" |
fzf \
    --preview "$ECHO" \
    --bind "enter:become:$ECHO" \
    --preview-window wrap
