set default-list := true

bootstrap: restore-selected

restore-selected:
    '{{ source_directory() }}/run-selected.sh' restore '{{ justfile_directory() }}/.mise' '{{ justfile_directory() }}/.scripts/helper'

record-selected:
    '{{ source_directory() }}/run-selected.sh' record '{{ justfile_directory() }}/.mise' '{{ justfile_directory() }}/.scripts/helper'
