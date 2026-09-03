#!/bin/sh

SEARCH="[ -n {q:1} ] && rg --files-with-matches {q:1} || true"
REPLACE="[ -n {+} ] && sd {q:1} {q:2} {+}"
PREVIEW="[ -n {+} ] && sd --preview {q:1} {q:2} {+}"

fzf --disabled --ansi --multi \
    --bind "start:reload:$SEARCH" \
    --bind "change:reload:$SEARCH" \
    --bind "enter:execute:$REPLACE" \
    --bind "enter:+reload:$SEARCH" \
    --preview "$PREVIEW"
