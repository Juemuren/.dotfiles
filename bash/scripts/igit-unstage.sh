#!/bin/sh

FILE_LIST="git diff --cached --name-only"
GIT_DIFF="git diff --cached --color=always -- {}"
GIT_RESTORE="git restore --staged -- {}"

fzf \
    --preview "$GIT_DIFF" \
    --header 'Enter: unstage' \
    --bind "start:reload:$FILE_LIST" \
    --bind "enter:execute($GIT_RESTORE)+reload($FILE_LIST)"
