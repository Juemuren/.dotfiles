#!/bin/sh

set -eu

PACKAGES_DIR=$1

brew list --formula --installed-on-request > "$PACKAGES_DIR/formulas.txt"
# brew 暂时不支持 --cask --installed-on-request
brew list --cask > "$PACKAGES_DIR/casks.txt"
