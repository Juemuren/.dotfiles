# Interactively
[[ "$-" != *i* ]] && return

# History
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# Window
shopt -s checkwinsize

# Path
export PATH="$HOME/.local/bin:$PATH"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Editor
export EDITOR="code"

# Integration
eval "$(fzf --bash)"
eval "$(zoxide init bash)"
eval "$(starship init bash)"
