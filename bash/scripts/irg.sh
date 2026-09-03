#!/bin/sh

SEARCH="rg --column --color=always --smart-case {q} || true"
PREVIEW="bat --style=numbers --color=always --highlight-line {2} {1}"

fzf --disabled --ansi \
    --delimiter : \
    --with-nth 4 \
    --bind "start:reload:$SEARCH" \
    --bind "change:reload:$SEARCH" \
    --bind "enter:become:$SEARCH" \
    --bind "focus:transform-preview-label:echo {r1}" \
    --preview "$PREVIEW" \
    --preview-window '+{2}/2'
