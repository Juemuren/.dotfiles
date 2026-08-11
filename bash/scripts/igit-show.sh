#!/bin/sh

GIT_SHOW="git show --color=always {1}"

git log --oneline --decorate --color=always \
    | fzf --ansi \
        --preview "$GIT_SHOW" \
        --bind "enter:become:$GIT_SHOW"
