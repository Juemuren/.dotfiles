# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME=""

# Use case-sensitive completion
# CASE_SENSITIVE="true"

# Use hyphen-insensitive completion
# HYPHEN_INSENSITIVE="true"

# Disable auto-update
zstyle ':omz:update' mode disabled

# Disable processing pasted characters
DISABLE_MAGIC_FUNCTIONS="true"

# Disable marking untracked files under VCS as dirty
DISABLE_UNTRACKED_FILES_DIRTY="true"

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

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"
# export LANG=zh_CN.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"
