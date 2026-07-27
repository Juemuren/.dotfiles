# Interactively
[[ "$-" != *i* ]] && return

# History
export PROMPT_COMMAND="history -a"

# Integration
eval "$(fzf --bash)"
eval "$(zoxide init bash)"
eval "$(starship init bash)"
