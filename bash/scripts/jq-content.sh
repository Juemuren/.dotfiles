#!/bin/sh

# 将 JSON 按内容展开作为索引

ECHO='echo "# Path\n" {r1} "\n# Content\n" {r2} | jq -r .'
BAT='bat --color=always -p -l markdown'

jq -r 'paths(scalars) as $p | ($p | join("/") | tojson) + "\t" + (getpath($p) | tojson)' "$1" |
fzf --delimiter '\t' \
    --with-nth=2 \
    --bind "enter:become:$ECHO | $BAT -P" \
    --preview "$ECHO | $BAT"\
    --preview-window wrap
