#!/bin/sh

BAT="bat --color=always --style=full {}"

fzf \
    --bind "enter:become:$BAT" \
    --preview "$BAT" \
    --preview-window 'wrap,up,80%'
