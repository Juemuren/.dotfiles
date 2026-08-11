#!/bin/sh

GIT_SHOW="git show --color=always {1}"
GIT_DIFFTOOL='git difftool "{r1}^!"'

git log --oneline --decorate --color=always \
    | fzf --ansi \
        --preview "$GIT_SHOW" \
        --header 'Enter: diff tool | Ctrl-P: print hash' \
        --bind "enter:become:$GIT_DIFFTOOL" \
        --bind "ctrl-p:become:echo {r1}"
