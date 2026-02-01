#!/bin/sh

BAT="bat --color=always --style=full {}"

fzf \
    --preview "$BAT" \
    --bind "enter:become:$BAT -P" \
    --preview-window 'wrap,up,80%'
