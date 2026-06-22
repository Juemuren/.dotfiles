#!/bin/sh

extract_extensions() {
    profile=$1
    script=$2

    jq -f "$script" "vscode/temp/$profile.code-profile" > "vscode/profiles/$profile/extensions.jsonc"
}

extract_settings() {
    profile=$1
    script=$2

    jq -r -f "$script" "vscode/temp/$profile.code-profile" > "vscode/profiles/$profile/settings.jsonc"
    dprint fmt "vscode/profiles/$profile/settings.jsonc"
}

profile=$1

if [ "$profile" = "global" ]; then
    extract_extensions "$profile" scripts/extract-vscode-extensions-global.jq
else
    extract_extensions "$profile" scripts/extract-vscode-extensions.jq
    extract_settings "$profile" scripts/extract-vscode-settings.jq
fi
