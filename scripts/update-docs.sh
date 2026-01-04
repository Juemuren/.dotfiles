#!/bin/sh

update_section() {
    file=$1
    marker=$2
    content=$3
    
    sd -f s \
        "<!-- $marker:START -->.*<!-- $marker:END -->" \
        "<!-- $marker:START -->\n$content\n<!-- $marker:END -->" \
        "$file"
}

TOOL_LIST="$(fd -d 1 --format '* {/.}')"
update_section README.md TOOL-LIST "$TOOL_LIST"
