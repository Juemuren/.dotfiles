#!/bin/sh

set -eu

selected=$1
modules_file=$2
helper_dir=$3
bootstrap=$4

jq -r \
    --arg selected "$selected" \
    --argjson bootstrap "$bootstrap" \
    -f "$helper_dir/select-modules.jq" \
    "$modules_file"
