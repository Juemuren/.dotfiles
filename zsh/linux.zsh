# shellcheck shell=bash disable=SC1090,SC1091,SC2034
# https://github.com/ohmyzsh/ohmyzsh/wiki/Settings

# Path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
export MANPATH="/usr/local/man:$MANPATH"

# homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

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

# carapace
source <(carapace _carapace)
