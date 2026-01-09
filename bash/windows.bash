# No interactively
[[ "$-" != *i* ]] && return

# https://code.visualstudio.com/docs/terminal/profiles#_git-bash
export PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases#auto-launching-ssh-agent-on-git-for-windows
# env=~/.ssh/agent.env
# agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }
# agent_start () {
#     (umask 077; ssh-agent >| "$env")
#     . "$env" >| /dev/null ; }
# agent_load_env
# agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)
# if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
#     agent_start
#     ssh-add
# elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
#     ssh-add
# fi
# unset env

# Integration
eval "$(thefuck --alias)"
eval "$(fzf --bash)"
eval "$(starship init bash)"
eval "$(zoxide init bash)"
