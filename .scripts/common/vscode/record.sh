#!/bin/bash

set -eu

SCRIPT_DIR=$(dirname "$0")
# shellcheck source-path=SCRIPTDIR
source "$SCRIPT_DIR/helper/profiles.sh"

PROFILES_DIR=$1
GLOBAL_EXTENSIONS_FILE="$HOME/.vscode/extensions/extensions.json"

extract_profile_extensions() {
    local profile_name=$1
    local extensions_file
    extensions_file="$APPDATA/Code/User/profiles/$(extract_profile_id "$profile_name")/extensions.json"

    jq -br \
        --slurpfile global_extensions "$GLOBAL_EXTENSIONS_FILE" \
        -f "$SCRIPT_DIR/helper/extract-profile-extensions.jq" \
        "$extensions_file" > "$PROFILES_DIR/$profile_name/extensions.txt"
}

extract_global_extensions() {
    jq -br \
        -f "$SCRIPT_DIR/helper/extract-global-extensions.jq" \
        "$GLOBAL_EXTENSIONS_FILE" > "$PROFILES_DIR/$GLOBAL_PROFILE_NAME/extensions.txt"
}

extract_all_extensions() {
    extract_global_extensions
    for_each_profile "$PROFILES_DIR" extract_profile_extensions
}

profile_name=$2

case "$profile_name" in
    "$GLOBAL_PROFILE_NAME")
        extract_global_extensions
        ;;
    all)
        extract_all_extensions
        ;;
    *)
        extract_profile_extensions "$profile_name"
        ;;
esac
