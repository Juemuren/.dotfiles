#!/usr/bin/env bash

set -euo pipefail

if git diff --cached --quiet; then
    echo "No staged changes."
    exit 1
fi

commit=$(
    git log --no-merges --format='%h %s' |
        fzf --no-multi \
            --prompt='Fixup> ' \
            --preview='git show --color=always {1}' \
            --preview-window='right:60%' |
        cut -d' ' -f1
) || exit 0

[[ -n "$commit" ]] || exit 0

git commit --fixup="$commit"
GIT_SEQUENCE_EDITOR=true \
    git rebase -i --autosquash "${commit}^"
