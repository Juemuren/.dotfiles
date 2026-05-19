# shellcheck shell=bash disable=SC2034 disable=SC1091
# https://github.com/ohmyzsh/ohmyzsh/wiki/Settings

# Path
export PATH="$HOME/.local/bin:$PATH"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME=""

# Set auto-update behavior
zstyle ':omz:update' mode reminder

# Disable processing pasted characters
DISABLE_MAGIC_FUNCTIONS="true"

# Load plugins
plugins=(
    aliases
    fzf
    tldr
    starship
    zoxide
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Disable all aliases
zstyle ':omz:*' aliases no

source "$ZSH/oh-my-zsh.sh"

# User configuration

export EDITOR="code"
export MANPATH="/usr/local/man:$MANPATH"
# export LANG=zh_CN.UTF-8
