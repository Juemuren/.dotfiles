#!/bin/sh

FILE_LIST="git diff --name-only"
GIT_DIFF="git diff --color=always -- {}"
GIT_ADD="git add -- {}"

fzf \
    --preview "$GIT_DIFF" \
    --header 'Enter: stage' \
    --bind "start:reload:$FILE_LIST" \
    --bind "enter:execute($GIT_ADD)+reload($FILE_LIST)"
