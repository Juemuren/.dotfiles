#!/bin/sh

set -eu

config_dir=$1
helper_dir=$2
modules_file=$3

has_include_query=$helper_dir/has-include.jq
query_file=$helper_dir/select-modules.jq

include_records=$(
    while IFS= read -r module; do
        config_file=$config_dir/config.$module.toml
        config_keys=$(mise config explain --file "$config_file" --json) || exit
        has_include=$(printf '%s\n' "$config_keys" | jq -r -f "$has_include_query") || exit
        if [ "$has_include" = true ]; then
            include_json=$(mise config get --file "$config_file" include) || exit
            printf '%s\t%s\n' "$module" "$include_json"
        fi
    done < "$modules_file"
)

printf '%s\n' "$include_records" |
    jq -R -s -r \
        --arg selected "${MISE_ENV-}" \
        --rawfile available "$modules_file" \
        -f "$query_file"
