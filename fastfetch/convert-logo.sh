#!/bin/sh
set -eu

if [ "$#" -ne 3 ]; then
    printf 'Usage: %s braille|block INPUT OUTPUT|-\n' "$0" >&2
    exit 2
fi

mode=$1
input=$2
output=$3

case "$mode" in
    braille)
        set -- --format symbols --symbols braille --colors none --size 48x24 --polite on
        ;;
    block)
        set -- --format symbols --symbols block --colors full --size 48x24 --polite on
        ;;
    *)
        printf 'Unknown mode: %s (use braille or block)\n' "$mode" >&2
        exit 2
        ;;
esac

if [ "$output" = - ]; then
    chafa "$@" "$input"
else
    if [ -e "$output" ]; then
        printf 'Output already exists: %s\n' "$output" >&2
        exit 1
    fi
    chafa "$@" "$input" > "$output"
fi
