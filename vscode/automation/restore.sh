#!/bin/bash

set -eu

SCRIPT_DIR=$(dirname "$0")
# shellcheck source-path=SCRIPTDIR
source "$SCRIPT_DIR/helper/profiles.sh"

PROFILES_DIR=$1

install_profile_extensions() {
    local profile=$1

    while IFS= read -r extension; do
        code --install-extension "$extension" --profile "$profile" || return
    done < "$PROFILES_DIR/$profile/extensions.txt"
}

install_global_extensions() {
    # code 目前不支持在安装扩展时应用到全部配置文件，需要后续手动设置
    while IFS= read -r extension; do
        code --install-extension "$extension" || return
    done < "$PROFILES_DIR/$GLOBAL_PROFILE_NAME/extensions.txt"
}

install_all_extensions() {
    install_global_extensions
    for_each_profile "$PROFILES_DIR" install_profile_extensions
}

profile_name=$2

case "$profile_name" in
    "$GLOBAL_PROFILE_NAME")
        install_global_extensions
        ;;
    all)
        install_all_extensions
        ;;
    *)
        install_profile_extensions "$profile_name"
        ;;
esac
