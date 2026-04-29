#!/bin/sh

RG='rg --column --color=always --smart-case {q}'

fzf --disabled --ansi \
    --delimiter : \
    --with-nth=4 \
    --bind "start:reload:$RG" \
    --bind "change:reload:$RG" \
    --bind "enter:become:$RG" \
    --bind="focus:transform-preview-label:echo {r1}" \
    --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
    --preview-window '+{2}/2'
