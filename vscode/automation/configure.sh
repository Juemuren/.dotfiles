#!/bin/bash

set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source-path=SCRIPTDIR
source "$SCRIPT_DIR/helper/profiles.sh"

PROFILES_DIR=$1
OUTPUT_FILE=$2
: > "$OUTPUT_FILE"

write_profile_config() {
    local profile_name=$1
    local profile_id
    profile_id=$(extract_profile_id "$profile_name") || return
    local key
    key="dotfiles.\"$VSCODE_USER_TARGET/profiles/$profile_id/settings.json\""

    mise config set --file "$OUTPUT_FILE" "$key.source" "profiles/$profile_name/settings.jsonc"
    mise config set --file "$OUTPUT_FILE" "$key.mode" symlink
}

for_each_profile "$PROFILES_DIR" write_profile_config
