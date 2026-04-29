#!/bin/sh

RG="rg --files-with-matches {q:1}"
SD="sd {q:1} {q:2} {+}"

fzf --disabled --ansi --multi \
    --bind "change:reload:$RG" \
    --bind "enter:execute:$SD" \
    --bind "enter:+reload:$RG" \
    --preview "$SD --preview"
