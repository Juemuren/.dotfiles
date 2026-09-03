#!/bin/sh

FILES="git diff --cached --name-only"
DIFF="git diff --cached --color=always -- {}"
UNSTAGE="git restore --staged -- {}"

fzf \
    --preview "$DIFF" \
    --header 'Enter: unstage' \
    --bind "start:reload:$FILES" \
    --bind "enter:execute($UNSTAGE)+reload($FILES)"
