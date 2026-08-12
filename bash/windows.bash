# Interactively
[[ "$-" != *i* ]] && return

# History
export PROMPT_COMMAND="history -a"

# Integration
# https://github.com/jdx/mise/discussions/3961
eval "$(
    mise activate bash \
        | awk '
            { print }

            index($0, "eval \"$(mise hook-env ") ||
            index($0, "eval \"$(command \"$__MISE_EXE\" ") {
                print "export PATH=\"$(/usr/bin/cygpath -u -p \"$PATH\")\""
            }
        '
)"
eval "$(fzf --bash)"
eval "$(zoxide init bash)"
eval "$(starship init bash)"
