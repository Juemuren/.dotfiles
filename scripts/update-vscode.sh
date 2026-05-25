#!/bin/sh

extract_extensions() {
    profile=$1
    script=$2

    jq -f "$script" "vscode/$profile/$profile.code-profile" > "vscode/$profile/extensions.jsonc"
}

profile=$1

if [ "$profile" = "default" ]; then
    extract_extensions "$profile" scripts/extract-extensions-global.jq
else
    extract_extensions "$profile" scripts/extract-extensions.jq
fi
