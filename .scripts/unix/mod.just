set default-list := true

bootstrap: restore-selected

restore-selected:
    '{{ source_directory() }}/restore-selected.sh' '{{ justfile_directory() }}/.mise' '{{ justfile_directory() }}/.scripts/helper'

record-selected:
    '{{ source_directory() }}/record-selected.sh' '{{ justfile_directory() }}/.mise' '{{ justfile_directory() }}/.scripts/helper'
