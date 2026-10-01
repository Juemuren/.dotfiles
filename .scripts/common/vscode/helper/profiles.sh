#!/bin/bash

VSCODE_HELPER_DIR=$(dirname "${BASH_SOURCE[0]}")
GLOBAL_PROFILE_NAME="global"

# 提取 $1 的 location
extract_profile_id() {
    local profile_name=$1
    local storage_file="$APPDATA/Code/User/globalStorage/storage.json"

    jq -ber \
        --arg profile_name "$profile_name" \
        -f "$VSCODE_HELPER_DIR/extract-profile-id.jq" \
        "$storage_file"
}

# 对 $1 下的每个非 global profile 调用 $2 函数，该函数把 profile 的名称作为参数
for_each_profile() {
    local profiles_dir=$1
    local action=$2
    local profile_dir profile_name

    for profile_dir in "$profiles_dir"/*/; do
        profile_name=$(basename "$profile_dir")
        if [ "$profile_name" != "$GLOBAL_PROFILE_NAME" ]; then
            "$action" "$profile_name" || return
        fi
    done
}
