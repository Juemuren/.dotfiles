#!/bin/sh

PREVIEW="bat --color=always --style=full {}"

fzf \
    --bind "enter:become:$PREVIEW" \
    --preview "$PREVIEW" \
    --preview-window 'wrap,up,80%'
