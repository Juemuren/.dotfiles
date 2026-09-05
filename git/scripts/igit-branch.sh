#!/bin/sh

BRANCHES='git branch --format="%(refname:short)"'
LOG="git log --oneline --decorate --color=always -20 {}"

fzf \
    --preview "$LOG" \
    --header 'Enter: switch | Ctrl-D: delete' \
    --bind "start:reload($BRANCHES)" \
    --bind 'enter:become(git switch {})' \
    --bind "ctrl-d:execute(git branch -d {})+reload($BRANCHES)"
