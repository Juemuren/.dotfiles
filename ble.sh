# https://github.com/akinomyoga/ble.sh/wiki/Performance

# https://github.com/akinomyoga/ble.sh/wiki/Performance#13-slow-file-systems
bleopt highlight_timeout_async=500
bleopt highlight_timeout_sync=50
bleopt highlight_eval_word_limit=20
bleopt complete_menu_color=off
bleopt complete_menu_color_match=on

# https://github.com/akinomyoga/ble.sh/wiki/Performance#14-slow-completions
bleopt complete_limit_auto=200
bleopt complete_limit_auto_menu=10
bleopt complete_timeout_auto=500
bleopt complete_timeout_compvar=10
bleopt complete_polling_cycle=5
bleopt complete_menu_maxlines=5
bleopt complete_menu_style=dense

# https://github.com/akinomyoga/ble.sh/wiki/Performance#15-long-command-line
bleopt line_limit_length=1000
bleopt history_limit_length=1000

# https://github.com/akinomyoga/ble.sh/wiki/Performance#16-history
bleopt history_share=1

# https://github.com/akinomyoga/ble.sh#28-fzf-integration
source /etc/profile.d/bash_completion.sh

ble-import -d integration/fzf-completion
ble-import -d integration/fzf-key-bindings

# https://github.com/akinomyoga/ble.sh#22-disable-features
bleopt complete_auto_complete=
bleopt complete_auto_menu=
bleopt complete_auto_history=
bleopt complete_ambiguous=
bleopt complete_menu_complete=
bleopt complete_menu_filter=
bleopt prompt_eol_mark=''
bleopt exec_errexit_mark=
bleopt exec_elapsed_mark=
bleopt exec_exit_mark=
bleopt edit_marker=
bleopt edit_marker_error=