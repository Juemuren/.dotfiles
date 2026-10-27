#!/bin/bash

set -e

installer=$(curl -fsSL https://raw.githubusercontent.com/Juemuren/.dotfiles/master/brew/automation/install.sh)
bash -c "$installer"
"${BREW_ROOT:-/home/linuxbrew/.linuxbrew}/bin/brew" install mise
