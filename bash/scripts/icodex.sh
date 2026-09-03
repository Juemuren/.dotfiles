#!/bin/sh

CODEX_SESSIONS="$HOME/.codex/sessions"
if [ "$OS" = "Windows_NT" ]; then
    CODEX_SESSIONS=$(cygpath --windows "$CODEX_SESSIONS")
fi

JQ_FILTER_CONTENT='
    select(.type == "response_item" and .payload.type == "message")
        | if .payload.role == "user" then "---\n# User\n---\n\n"
            elif .payload.role == "assistant" then "---\n# Assistant\n---\n\n"
            else empty
            end
        + ([.payload.content[]? | .text // empty] | join("\n"))
        + "\n"
'
JQ_FILTER_ID='select(.type == "session_meta") | .payload.id'

RG="rg --files-with-matches --smart-case --glob '*.jsonl' {q} '$CODEX_SESSIONS'"
MARKDOWN="jq -r '$JQ_FILTER_CONTENT' {}"
BAT="bat --color=always --style=plain --language=markdown"
SESSION_ID="jq -r '$JQ_FILTER_ID' {}"

fzf --disabled --with-shell 'sh -c' \
    --header 'Enter: open | Ctrl-R: resume' \
    --bind "start:reload:$RG" \
    --bind "change:reload:$RG" \
    --bind "enter:become:$MARKDOWN | $BAT --paging=always" \
    --bind "ctrl-r:become:codex resume \$($SESSION_ID)" \
    --preview "$MARKDOWN | $BAT" \
    --preview-window 'wrap,up,70%'
