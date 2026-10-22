# https://learn.microsoft.com/en-us/windows/terminal/tutorials/shell-integration

[[ $- == *i* && -n ${WT_SESSION-} && ${TERM_PROGRAM-} != vscode ]] || return
[[ ${BASH_VERSINFO[0]} -gt 4 || ( ${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -ge 4 ) ]] || return
[[ ${__WT_INTEGRATION_LOADED-} ]] && return
__WT_INTEGRATION_LOADED=1

__wt_capture_status() {
    __wt_exit_status=$?
    return "$__wt_exit_status"
}

__wt_prompt_command() {
    local cwd prefix

    if [[ -n ${__wt_wrapped_ps1-} && ${PS1-} == "$__wt_wrapped_ps1" ]]; then
        PS1=$__wt_unwrapped_ps1
    fi

    if [[ ${__wt_prompt_shown-} ]]; then
        if [[ ${__wt_command_started-} ]]; then
            prefix="\\[\\e]133;D;${__wt_exit_status}\\a\\]"
        else
            prefix='\[\e]133;D\a\]'
        fi
    fi

    __wt_prompt_shown=1
    __wt_command_started=

    # Windows Terminal needs a Windows path for new tabs in the same directory.
    cwd=$(cygpath -w -- "$PWD") || cwd=
    prefix+='\[\e]133;A\a\]'
    [[ $cwd ]] && prefix+="\\[\\e]9;9;\\\"${cwd}\\\"\\a\\]"
    __wt_unwrapped_ps1=$PS1
    PS1="${prefix}${PS1}\\[\\e]133;B\\a\\]"
    __wt_wrapped_ps1=$PS1
}

# Keep Starship's PS0 timing hook and mark the start of command output.
PS0+='${__wt_command_started:$((__wt_command_started=1,0)):0}'$'\e]133;C\a'

# The first hook preserves $? for Starship and the final hook wraps its PS1.
PROMPT_COMMAND=(__wt_capture_status "${PROMPT_COMMAND[@]}" __wt_prompt_command)
