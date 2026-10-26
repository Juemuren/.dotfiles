#!/bin/bash

VSCODE_HELPER_DIR=$(dirname "${BASH_SOURCE[0]}")
GLOBAL_PROFILE_NAME="global"
# Keep ~ literal in targets.
VSCODE_HOME_TARGET='~'

case "$(uname -s)" in
    Linux)
        export VSCODE_USER_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/Code/User"
        export VSCODE_USER_TARGET="${XDG_CONFIG_HOME:-$VSCODE_HOME_TARGET/.config}/Code/User"
        ;;
    MINGW* | MSYS* | CYGWIN*)
        export VSCODE_USER_DIR="$APPDATA/Code/User"
        export VSCODE_USER_TARGET="$VSCODE_HOME_TARGET/AppData/Roaming/Code/User"
        ;;
    *)
        echo "Unsupported platform: $(uname -s)" >&2
        return 1
        ;;
esac

# 提取 $1 的 location
extract_profile_id() {
    local profile_name=$1
    local storage_file="$VSCODE_USER_DIR/globalStorage/storage.json"

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
