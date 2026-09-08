# Interactively
[[ "$-" != *i* ]] && return

# History
export PROMPT_COMMAND="history -a"

# Integration
eval "$(mise activate bash)"
eval "$(fzf --bash)"
eval "$(starship init bash)"
eval "$(zoxide init bash)"
