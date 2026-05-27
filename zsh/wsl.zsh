# shellcheck shell=bash disable=SC2034 disable=SC1091
# https://github.com/ohmyzsh/ohmyzsh/wiki/Settings

# Path
export PATH="$HOME/.local/bin:$PATH"

# >>> oh my zsh >>>
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
zstyle ':omz:update' mode reminder
DISABLE_MAGIC_FUNCTIONS="true"
plugins=(
    aliases
    brew
    fzf
    mise
    tldr
    starship
    zoxide
    zsh-autosuggestions
    zsh-syntax-highlighting
)
zstyle ':omz:*' aliases no
source "$ZSH/oh-my-zsh.sh"
# <<< oh my zsh <<<

# User configuration
export EDITOR="code"
export MANPATH="/usr/local/man:$MANPATH"
