set default-list := true

bootstrap: restore-selected

restore-selected:
    '{{ source_directory() }}/restore-selected.sh'
