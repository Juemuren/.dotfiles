#!/bin/bash

set -e

if command -v brew > /dev/null 2>&1; then
    brew_bin=$(command -v brew)
else
    brew_bin=${BREW_ROOT:-/home/linuxbrew/.linuxbrew}/bin/brew
fi

if [ ! -x "$brew_bin" ]; then
    installer=$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
    if [ -n "${BREW_ROOT:-}" ]; then
        NONINTERACTIVE=1 bash -c "$installer" -- --path "$BREW_ROOT"
    else
        NONINTERACTIVE=1 bash -c "$installer"
    fi
fi

if [ ! -x "$brew_bin" ]; then
    echo 'error: brew not found after install' >&2
    exit 1
fi

"$brew_bin" install mise

case "${SHELL##*/}" in
    bash) shell_rc=$HOME/.bashrc ;;
    zsh) shell_rc=$HOME/.zshrc ;;
    *) exit 0 ;;
esac

brew_line="eval \"\$($brew_bin shellenv)\""
if [ ! -f "$shell_rc" ] || ! grep -Fqx "$brew_line" "$shell_rc"; then
    printf '\n%s\n' "$brew_line" >> "$shell_rc"
fi
