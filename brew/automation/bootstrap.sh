#!/bin/bash

set -e

if command -v brew > /dev/null 2>&1; then
    brew_bin=$(command -v brew)
else
    brew_bin=$1/bin/brew
fi

if [ ! -x "$brew_bin" ]; then
    installer=$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
    bash -c "$installer"
fi

case "${SHELL##*/}" in
    bash) shell_rc=$HOME/.bashrc ;;
    zsh) shell_rc=$HOME/.zshrc ;;
    *) exit 0 ;;
esac

brew_line="eval \"\$($brew_bin shellenv)\""
if [ ! -f "$shell_rc" ] || ! grep -Fqx "$brew_line" "$shell_rc"; then
    printf '\n%s\n' "$brew_line" >> "$shell_rc"
fi
