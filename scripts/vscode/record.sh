#!/bin/sh

set -eu

SCRIPT_DIR=$(dirname "$0")
PROFILES_DIR=$1

extract_extensions() {
    profile=$1
    script=$2

    jq -f "$script" "$PROFILES_DIR/$profile/$profile.code-profile" > "$PROFILES_DIR/$profile/extensions.jsonc"
}

profile=$2

if [ "$profile" = "global" ]; then
    extract_extensions "$profile" "$SCRIPT_DIR/extract-extensions-global.jq"
else
    extract_extensions "$profile" "$SCRIPT_DIR/extract-extensions.jq"
fi
