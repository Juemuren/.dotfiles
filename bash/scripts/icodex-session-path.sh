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
SED_EXPRESSION='s#^.*[\\/]rollout-(.*)\.jsonl$#&\t\1#'

SESSION_CONTENT="jq -r '$JQ_FILTER_CONTENT' {1}"
SESSION_ID="jq -r '$JQ_FILTER_ID' {1}"

SEARCH="
    fd --type file --extension jsonl --fixed-strings {q} '$CODEX_SESSIONS' \
        | sed -E '$SED_EXPRESSION'
"
RENDER="bat --color=always --style=plain --language=markdown"
PREVIEW="
    [ -n {1} ] || exit

    $SESSION_CONTENT \
        | $RENDER
"

fzf --disabled --with-shell 'sh -c' \
    --delimiter '\t' \
    --with-nth 2 \
    --header 'Enter: browser | Ctrl-E: edit | Ctrl-R: resume' \
    --bind "start:reload:$SEARCH" \
    --bind "change:reload:$SEARCH" \
    --bind "enter:become:$SESSION_CONTENT | $RENDER --paging=always" \
    --bind "ctrl-e:become:$EDITOR {1}" \
    --bind "ctrl-r:become:codex resume \$($SESSION_ID)" \
    --preview "$PREVIEW" \
    --preview-window 'wrap,up,70%'
