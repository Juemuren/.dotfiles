#!/bin/sh

set -eu

selected=,${MISE_ENV-},
modules_file=$(dirname "$0")/restore-modules.txt

while read -r module; do
    case "$selected" in
        *,"$module",*)
            just "$module::restore" ;;
    esac
done < "$modules_file"
