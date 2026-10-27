#!/bin/sh

set -eu

script_dir=$(dirname "$0")
action=$1
config_dir=$2
helper_dir=$3

case "$action" in
    record | restore) ;;
    *)
        echo "error: unknown action: $action" >&2
        exit 2
        ;;
esac

modules=$(
    "$script_dir/select-modules.sh" \
        "$config_dir" \
        "$helper_dir" \
        "$script_dir/modules.txt"
)

printf '%s\n' "$modules" | while IFS= read -r module; do
    [ -n "$module" ] || continue
    just "$module::$action"
done
