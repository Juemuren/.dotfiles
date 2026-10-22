# shellcheck disable=SC1091
# Interactively
[[ "$-" != *i* ]] && return

# History
export PROMPT_COMMAND="history -a"

# Integration
eval "$(mise activate bash)"
eval "$(fzf --bash)"
eval "$(starship init bash)"
eval "$(zoxide init bash)"
eval "$(carapace _carapace bash)"
eval "$(atuin init bash --disable-ai --disable-up-arrow)"

# Windows Terminal
if [[ -n ${WT_SESSION-} && ${TERM_PROGRAM-} != vscode ]]; then
    source "$HOME/.config/bash/integrations/WindowsTerminal.bash"
fi
