#!/bin/sh

FILES="git diff --name-only"
DIFF="git diff --color=always -- {}"
STAGE="git add -- {}"

fzf \
    --preview "$DIFF" \
    --header 'Enter: stage' \
    --bind "start:reload:$FILES" \
    --bind "enter:execute($STAGE)+reload($FILES)"
