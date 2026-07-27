# shellcheck shell=bash disable=SC2034 disable=SC1091
# https://github.com/ohmyzsh/ohmyzsh/wiki/Settings

# >>> oh my zsh >>>
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
zstyle ':omz:update' mode disabled
DISABLE_MAGIC_FUNCTIONS="true"
plugins=(
    aliases
    fzf
    tldr
    starship
    zoxide
    zsh-autosuggestions
    zsh-syntax-highlighting
)
zstyle ':omz:*' aliases no
source "$ZSH/oh-my-zsh.sh"
# <<< oh my zsh <<<
