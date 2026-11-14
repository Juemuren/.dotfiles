#!/bin/bash

update_section() {
    local file=$1
    local marker=$2
    local content
    content=$(cat)

    case $file in
        *.md)
            begin="<!-- $marker:BEGIN -->"
            end="<!-- $marker:END -->"
            ;;
        *.toml)
            begin="# $marker:BEGIN"
            end="# $marker:END"
            ;;
    esac

    sd -A -f s \
        "$begin.*$end" \
        "$begin\n$content\n$end" \
        "$file"
}
