#!/bin/sh

set -eu

script_dir=$(dirname "$0")
config_dir=$1
helper_dir=$2

modules=$(
    "$helper_dir/modules.sh" \
        "$config_dir" \
        "$helper_dir" \
        "$script_dir/modules.txt"
)

printf '%s\n' "$modules" | while IFS= read -r module; do
    [ -n "$module" ] || continue
    just "$module::record"
done
