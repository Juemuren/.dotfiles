#!/bin/sh

set -eu

PACKAGES_DIR=$1

xargs brew install --formula < "$PACKAGES_DIR/formulas.txt"
xargs brew install --cask < "$PACKAGES_DIR/casks.txt"
