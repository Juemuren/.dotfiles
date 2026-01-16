# Interactively
[[ "$-" != *i* ]] && return

# History
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# Window
shopt -s checkwinsize

# Editor
export EDITOR="code"
export VISUAL="$EDITOR"

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Integration
eval "$(fzf --bash)"
eval "$(zoxide init bash)"
eval "$(starship init bash)"
