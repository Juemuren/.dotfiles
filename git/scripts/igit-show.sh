#!/bin/sh

COMMITS="git show --color=always {1}"
DIFFTOOL='git difftool "{r1}^!"'

git log --oneline --decorate --color=always |
    fzf --ansi \
        --preview "$COMMITS" \
        --header 'Enter: diff tool | Ctrl-P: print hash' \
        --bind "enter:become:$DIFFTOOL" \
        --bind "ctrl-p:become:echo {r1}"
