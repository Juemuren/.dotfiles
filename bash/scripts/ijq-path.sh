#!/bin/sh

file=$1

JQ_GET_PATHS='paths | tojson'

PREVIEW="echo {r} && jq -C getpath({}) $file"

jq -r "$JQ_GET_PATHS" "$file" \
    | fzf \
        --bind "enter:become:$PREVIEW" \
        --preview "$PREVIEW" \
        --preview-window wrap
