#!/bin/sh

TOOL_LIST="$(fd -d 1 --format '* {/.}')"

sd -f s \
    "<!-- TOOL-LIST:START -->.*<!-- TOOL-LIST:END -->" \
    "<!-- TOOL-LIST:START -->\n$TOOL_LIST\n<!-- TOOL-LIST:END -->" \
    README.md