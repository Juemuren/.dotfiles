#!/bin/bash

set -eu

SCRIPT_DIR=$(dirname "$0")
# shellcheck source-path=SCRIPTDIR
source "$SCRIPT_DIR/helper/profiles.sh"

PROFILES_DIR=$1
ENV_FILE=$2

generate_profile_env() {
    local profile_name=$1
    local profile_id
    profile_id=$(extract_profile_id "$profile_name") || return
    printf 'vscode_%s_id="%s"\n' "$profile_name" "$profile_id"
}

env_content=$(for_each_profile "$PROFILES_DIR" generate_profile_env)
mkdir -p "$(dirname "$ENV_FILE")"
printf '%s\n' "$env_content" > "$ENV_FILE"
