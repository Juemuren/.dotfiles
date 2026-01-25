# Interactively
[[ "$-" != *i* ]] && return

# History
export PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# Integration
# export PYTHONIOENCODING="utf-8"
# eval "$(thefuck --alias)"
eval "$(fzf --bash)"
eval "$(zoxide init bash)"
eval "$(starship init bash)"
