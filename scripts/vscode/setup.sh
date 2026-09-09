#!/bin/sh

set -eu

SCRIPT_DIR=$(dirname "$0")
STORAGE="$APPDATA/Code/User/globalStorage/storage.json"

profile=$1

# TODO 成功提取 profile id，后续再考虑一下怎么处理

jq -er --arg profile "$profile" -f "$SCRIPT_DIR/extract-profile-id.jq" "$STORAGE"
