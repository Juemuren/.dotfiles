#!/bin/sh

extract_extensions() {
    profile=$1
    script=$2

    jq -f "$script" "vscode/$profile/$profile.code-profile" > "vscode/$profile/extensions.jsonc"
}

extract_settings() {
    profile=$1
    script=$2

    jq -r -f "$script" "vscode/$profile/$profile.code-profile" > "vscode/$profile/settings.jsonc"
}

profile=$1

if [ "$profile" = "global" ]; then
    extract_extensions "$profile" scripts/extract-extensions-global.jq
else
    extract_extensions "$profile" scripts/extract-extensions.jq
    extract_settings "$profile" scripts/extract-settings.jq
fi
