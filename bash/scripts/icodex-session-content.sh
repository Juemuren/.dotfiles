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
JQ_FILTER_MATCHES='
    [
        .[]
            | select(.type == "match")
            | select(
                .data.lines.text
                | fromjson
                | .type == "response_item"
                    and .payload.type == "message"
                    and (.payload.role == "user" or .payload.role == "assistant")
            )
            | .data.path.text
    ]
    | unique[]
'
RG_PATTERN='"role":"(user|assistant)"'
DATE_TIME_PATTERN='[[:digit:]]+-[[:digit:]]+-[[:digit:]]+T[[:digit:]]+-[[:digit:]]+-[[:digit:]]+'
UUID_PATTERN='[[:xdigit:]]+-[[:xdigit:]]+-[[:xdigit:]]+-[[:xdigit:]]+-[[:xdigit:]]+'
SED_EXPRESSION="s|^.*[\\\\/]rollout-($DATE_TIME_PATTERN)-($UUID_PATTERN)\.jsonl$|&\t\1\t\2|"

SESSION_CONTENT="jq -r '$JQ_FILTER_CONTENT' {1}"

SEARCH="
    if [ -z {q} ]; then
        rg --files-with-matches --glob '*.jsonl' '$RG_PATTERN' '$CODEX_SESSIONS'
    else
        rg --json --smart-case --glob '*.jsonl' {q} '$CODEX_SESSIONS' \
            | jq -rs '$JQ_FILTER_MATCHES'
    fi | sed -E '$SED_EXPRESSION'
"
RENDER="bat --color=always --style=plain --language=markdown"
PREVIEW="
    [ -n {1} ] || exit

    if [ -n {q} ]; then
        $SESSION_CONTENT \
            | $RENDER \
            | rg --color=always --context 3 --smart-case -- {q}
    else
        $SESSION_CONTENT \
            | $RENDER
    fi
"

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
