#!/bin/sh

RG='rg --column --color=always --smart-case {q}'

fzf --disabled --ansi \
    --bind "start:reload:$RG" \
    --bind "change:reload:$RG" \
    --bind "enter:become:$RG" \
    --delimiter : \
    --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
    --preview-window '+{2}/2'
