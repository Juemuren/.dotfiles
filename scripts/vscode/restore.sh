#!/bin/bash

set -eu

PROFILES_DIR=$1

get_extensions() {
    local profile=$1

    # TODO extensions 改为 txt 格式
    jq -er \
        ".recommendations[]" \
        "$PROFILES_DIR/$profile/extensions.jsonc"
}

install_extensions() {
    local profile=$1
    local extensions=$2

    for extension in $extensions; do
        code --install-extension "$extension" --profile "$profile"
    done
}

profile=$2

if [ "$profile" = "global" ]; then
    # code 目前不支持安装扩展时应用到全部配置文件
    exit 1
else
    extensions="$(get_extensions "$profile")"
    install_extensions "$profile" "$extensions"
fi
