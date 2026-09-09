#!/bin/bash

set -eu

SCRIPT_DIR=$(dirname "$0")
PROFILES_DIR=$1
GLOBAL_EXTENSIONS_FILE="$HOME/.vscode/extensions/extensions.json"
GLOBAL_PROFILE_NAME="global"

extract_profile_id() {
    local profile_name=$1
    local storage_file="$APPDATA/Code/User/globalStorage/storage.json"

    jq -er \
        --arg profile_name "$profile_name" \
        -f "$SCRIPT_DIR/extract-profile-id.jq" \
        "$storage_file"
}

extract_profile_extensions() {
    local profile_name=$1
    local extensions_file
    extensions_file="$APPDATA/Code/User/profiles/$(extract_profile_id "$profile_name")/extensions.json"

    jq -er \
        --slurpfile global_extensions "$GLOBAL_EXTENSIONS_FILE" \
        -f "$SCRIPT_DIR/extract-profile-extensions.jq" \
        "$extensions_file" |
        sort > "$PROFILES_DIR/$profile_name/extensions.txt"
}

extract_global_extensions() {
    jq -er \
        -f "$SCRIPT_DIR/extract-global-extensions.jq" \
        "$GLOBAL_EXTENSIONS_FILE" |
        sort > "$PROFILES_DIR/$GLOBAL_PROFILE_NAME/extensions.txt"
}

profile_name=$2

if [ "$profile_name" = "$GLOBAL_PROFILE_NAME" ]; then
    extract_global_extensions
else
    extract_profile_extensions "$profile_name"
fi
