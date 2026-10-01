#!/bin/bash

set -eu

SCRIPT_DIR=$(dirname "$0")
PROFILES_DIR=$1
ENV_FILE=$2
GLOBAL_PROFILE_NAME="global"

extract_profile_id() {
    local profile_name=$1
    local storage_file="$APPDATA/Code/User/globalStorage/storage.json"

    jq -ber \
        --arg profile_name "$profile_name" \
        -f "$SCRIPT_DIR/record/extract-profile-id.jq" \
        "$storage_file"
}

generate_env() {
    local profile_dir profile_name profile_id

    for profile_dir in "$PROFILES_DIR"/*/; do
        profile_name=$(basename "$profile_dir")
        if [ "$profile_name" != "$GLOBAL_PROFILE_NAME" ]; then
            profile_id=$(extract_profile_id "$profile_name") || return
            printf 'vscode_%s_id="%s"\n' "$profile_name" "$profile_id"
        fi
    done
}

env_content=$(generate_env)
mkdir -p "$(dirname "$ENV_FILE")"
printf '%s\n' "$env_content" > "$ENV_FILE"
