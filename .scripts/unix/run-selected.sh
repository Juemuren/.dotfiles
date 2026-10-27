#!/bin/sh

set -eu

script_dir=$(dirname "$0")
action=$1
selected=$2
helper_dir=$3
bootstrap=${4-false}

case "$action" in
    record | restore) ;;
    *)
        echo "error: unknown action: $action" >&2
        exit 2
        ;;
esac

modules=$(
    "$script_dir/select-modules.sh" \
        "$selected" \
        "$script_dir/modules.json" \
        "$helper_dir" \
        "$bootstrap"
)

printf '%s\n' "$modules" | while IFS= read -r module; do
    [ -n "$module" ] || continue
    just "$module::$action"
done
