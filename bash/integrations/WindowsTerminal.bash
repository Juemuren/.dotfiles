# https://learn.microsoft.com/en-us/windows/terminal/tutorials/shell-integration

[[ $- == *i* && -n ${WT_SESSION-} && ${TERM_PROGRAM-} != vscode ]] || return
[[ ${BASH_VERSINFO[0]} -gt 4 || (${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -ge 4) ]] || return
[[ ${__WT_INTEGRATION_LOADED-} ]] && return
__WT_INTEGRATION_LOADED=1

__wt_save_exit_status() {
    __wt_last_exit_status=$?
    return "$__wt_last_exit_status"
}

__wt_before_prompt() {
    local cwd markers

    # Starship replaces PS1 each time; restore a static prompt before wrapping it again.
    if [[ -n ${__wt_wrapped_ps1-} && ${PS1-} == "$__wt_wrapped_ps1" ]]; then
        PS1=$__wt_unwrapped_ps1
    fi

    if [[ ${__wt_prompt_shown-} ]]; then
        if [[ ${__wt_command_started+x} ]]; then
            markers="\\[\\e]133;D;${__wt_last_exit_status}\\a\\]"
        else
            markers='\[\e]133;D\a\]'
        fi
    fi

    __wt_prompt_shown=1
    unset __wt_command_started

    # Windows Terminal needs a Windows path for new tabs in the same directory.
    cwd=$(cygpath -w -- "$PWD") || cwd=
    markers+='\[\e]133;A\a\]'
    [[ $cwd ]] && markers+="\\[\\e]9;9;\\\"${cwd}\\\"\\a\\]"
    __wt_unwrapped_ps1=$PS1
    PS1="${markers}${PS1}\\[\\e]133;B\\a\\]"
    __wt_wrapped_ps1=$PS1
}

# Keep $ literal until Bash expands PS0 before running a command.
PS0+="\${__wt_command_started=}"$'\e]133;C\a'

PROMPT_COMMAND=(__wt_save_exit_status "${PROMPT_COMMAND[@]}" __wt_before_prompt)
