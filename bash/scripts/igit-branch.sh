#!/bin/sh

GIT_BRANCH='git branch --format="%(refname:short)"'
GIT_LOG="git log --oneline --decorate --color=always -20 {}"

fzf \
    --preview "$GIT_LOG" \
    --header 'Enter: switch | Ctrl-D: delete' \
    --bind "start:reload($GIT_BRANCH)" \
    --bind 'enter:become(git switch {})' \
    --bind "ctrl-d:execute(git branch -d {})+reload($GIT_BRANCH)"
