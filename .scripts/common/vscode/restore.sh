#!/bin/bash

set -eu

PROFILES_DIR=$1

install_extensions() {
    local profile=$1

    while IFS= read -r extension; do
        code --install-extension "$extension" --profile "$profile"
    done < "$PROFILES_DIR/$profile/extensions.txt"
}

profile=$2

if [ "$profile" = "global" ]; then
    # code 目前不支持安装扩展时应用到全部配置文件
    exit 1
else
    install_extensions "$profile"
fi
