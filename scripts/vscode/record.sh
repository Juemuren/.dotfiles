#!/bin/bash

set -eu

SCRIPT_DIR=$(dirname "$0")
PROFILES_DIR=$1

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

    # TODO 和 *.code-profile 的导出结果有差异，会包含部分全局扩展
    jq -er \
        -f "$SCRIPT_DIR/extract-profile-extensions.jq" \
        "$APPDATA/Code/User/profiles/$profile_id/extensions.json" |
    sort > "$PROFILES_DIR/$profile_name/extensions.txt"
}

extract_glocal_extensions() {
    profile_name="global"

    jq -er \
        -f "$SCRIPT_DIR/extract-global-extensions.jq" \
        "$HOME/.vscode/extensions/extensions.json" |
    sort > "$PROFILES_DIR/$profile_name/extensions.txt"
}

if [ "$profile_name" = "global" ]; then
    extract_glocal_extensions
else
    profile_id=$(extract_profile_id "$profile_name")
    extract_profile_extensions "$profile_id"
fi
