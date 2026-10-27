set default-list := true

bootstrap: restore-bootstrap

restore-bootstrap:
    '{{ source_directory() }}/run-selected.sh' \
        restore \
        "${RESTORE_MODULES-}" \
        '{{ justfile_directory() }}/.scripts/helper' \
        true

restore-selected $MODULES="":
    '{{ source_directory() }}/run-selected.sh' \
        restore \
        "$MODULES" \
        '{{ justfile_directory() }}/.scripts/helper'

record-selected $MODULES="":
    '{{ source_directory() }}/run-selected.sh' \
        record \
        "$MODULES" \
        '{{ justfile_directory() }}/.scripts/helper'
