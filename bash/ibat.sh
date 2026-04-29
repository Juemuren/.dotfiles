#!/bin/sh

BAT="bat --color=always --style=full {}"

fzf \
    --bind "enter:become:$BAT -P" \
    --preview "$BAT" \
    --preview-window 'wrap,up,80%'
