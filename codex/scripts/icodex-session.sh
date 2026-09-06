#!/bin/sh

CODEX_SESSIONS="$HOME/.codex/sessions"
if [ "$OS" = "Windows_NT" ]; then
    CODEX_SESSIONS=$(cygpath --windows "$CODEX_SESSIONS")
fi

SCRIPT_DIR=$(dirname "$0")
SESSION_CONTENT_FILTER="$SCRIPT_DIR/session-content.jq"
SESSION_MATCHES_FILTER="$SCRIPT_DIR/session-matches.jq"

DATE_TIME_PATTERN='[[:digit:]]+-[[:digit:]]+-[[:digit:]]+T[[:digit:]]+-[[:digit:]]+-[[:digit:]]+'
UUID_PATTERN='[[:xdigit:]]+-[[:xdigit:]]+-[[:xdigit:]]+-[[:xdigit:]]+-[[:xdigit:]]+'
SED_EXPRESSION="s|^.*[\\\\/]rollout-($DATE_TIME_PATTERN)-($UUID_PATTERN)\.jsonl$|&\t\1\t\2|"
RG_PATTERN='"role":"(user|assistant)"'

SESSION_CONTENT="jq -r -f '$SESSION_CONTENT_FILTER' {1}"
RENDER="bat --color=always --style=plain --language=markdown"

case ${1:-} in
    path)
        SEARCH="
            fd --type file --extension jsonl --fixed-strings {q} '$CODEX_SESSIONS' |
                sed -E '$SED_EXPRESSION'
        "
        PREVIEW="
            [ -n {1} ] || exit

            $SESSION_CONTENT | $RENDER
        "
        ;;
    content)
        SEARCH="
            if [ -z {q} ]; then
                rg --files-with-matches --glob '*.jsonl' '$RG_PATTERN' '$CODEX_SESSIONS'
            else
                rg --json --smart-case --glob '*.jsonl' {q} '$CODEX_SESSIONS' |
                    jq -rs -f '$SESSION_MATCHES_FILTER'
            fi | sed -E '$SED_EXPRESSION'
        "
        PREVIEW="
            [ -n {1} ] || exit

            if [ -n {q} ]; then
                $SESSION_CONTENT | $RENDER | rg --color=always --context 3 --smart-case -- {q}
            else
                $SESSION_CONTENT | $RENDER
            fi
        "
        ;;
    *)
        printf 'Usage: %s {path|content}\n' "$(basename "$0")" >&2
        exit 2
        ;;
esac

fzf --disabled --with-shell 'sh -c' \
    --delimiter '\t' \
    --with-nth 2,3 \
    --header 'Enter: browser | Ctrl-E: edit | Ctrl-R: resume' \
    --bind "start:reload:$SEARCH" \
    --bind "change:reload:$SEARCH" \
    --bind "enter:become:$SESSION_CONTENT | $RENDER --paging=always" \
    --bind "ctrl-e:become:$EDITOR {1}" \
    --bind 'ctrl-r:become:codex resume {3}' \
    --preview "$PREVIEW" \
    --preview-window 'wrap,up,70%'
