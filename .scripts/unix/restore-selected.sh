#!/bin/sh

set -eu

script_dir=$(dirname "$0")
modules_file=$script_dir/restore-modules.txt
has_include_query=$script_dir/../helper/has-include.jq
query_file=$script_dir/../helper/restore-selected.jq
config_dir=$script_dir/../../.mise

includes=$(
    while IFS= read -r module; do
        config_file=$config_dir/config.$module.toml
        keys=$(mise config explain --file "$config_file" --json) || exit
        has_include=$(printf '%s\n' "$keys" | jq -r -f "$has_include_query") || exit
        if [ "$has_include" = true ]; then
            value=$(mise config get --file "$config_file" include) || exit
            printf '%s\t%s\n' "$module" "$value"
        fi
    done < "$modules_file"
)

modules=$(
    printf '%s\n' "$includes" |
    jq -R -s -r \
        --arg selected "${MISE_ENV-}" \
        --rawfile available "$modules_file" \
        -f "$query_file"
)

while IFS= read -r module; do
    [ -n "$module" ] || continue
    just "$module::restore"
done << EOF
$modules
EOF
