#!/bin/bash

set -e

if [ -x "${BREW_ROOT:-/home/linuxbrew/.linuxbrew}/bin/brew" ]; then
    exit 0
fi

installer=$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
if [ -n "${BREW_ROOT:-}" ]; then
    NONINTERACTIVE=1 bash -c "$installer" -- --path "$BREW_ROOT"
else
    NONINTERACTIVE=1 bash -c "$installer"
fi
