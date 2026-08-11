#!/bin/sh

RG="rg --column --color=always --smart-case {q}"
BAT="bat --style=numbers --color=always --highlight-line {2} {1}"

fzf --disabled --ansi \
    --delimiter : \
    --with-nth=4 \
    --bind "start:reload:$RG" \
    --bind "change:reload:$RG" \
    --bind "enter:become:$RG" \
    --bind="focus:transform-preview-label:echo {r1}" \
    --preview "$BAT" \
    --preview-window '+{2}/2'
