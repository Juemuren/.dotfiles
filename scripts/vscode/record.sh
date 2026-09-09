#!/bin/bash

set -eu

SCRIPT_DIR=$(dirname "$0")
PROFILES_DIR=$1
GLOBAL_EXTENSIONS="$HOME/.vscode/extensions/extensions.json"
GLOBAL_PROFILE_NAME="global"

profile_name=$2

extract_profile_id() {
    STORAGE="$APPDATA/Code/User/globalStorage/storage.json"

    jq -er \
        --arg profile_name "$profile_name" \
        -f "$SCRIPT_DIR/extract-profile-id.jq" \
        "$STORAGE"
}

extract_profile_extensions() {
    local profile_id=$1

    jq -er \
        --slurpfile global_extensions "$GLOBAL_EXTENSIONS" \
        -f "$SCRIPT_DIR/extract-profile-extensions.jq" \
        "$APPDATA/Code/User/profiles/$profile_id/extensions.json" |
        sort > "$PROFILES_DIR/$profile_name/extensions.txt"
}

extract_glocal_extensions() {
    jq -er \
        -f "$SCRIPT_DIR/extract-global-extensions.jq" \
        "$GLOBAL_EXTENSIONS" |
        sort > "$PROFILES_DIR/$GLOBAL_PROFILE_NAME/extensions.txt"
}

if [ "$profile_name" = "$GLOBAL_PROFILE_NAME" ]; then
    extract_glocal_extensions
else
    profile_id=$(extract_profile_id "$profile_name")
    extract_profile_extensions "$profile_id"
fi
