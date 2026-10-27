set default-list := true
set shell := ["pwsh", "-NoProfile", "-Command"]

bootstrap: set-env restore-bootstrap

set-env:
    & '{{ source_directory() }}/env.ps1'

restore-bootstrap:
    & '{{ source_directory() }}/run-selected.ps1' \
        -Action restore \
        -Selected ([string]$env:RESTORE_MODULES) \
        -HelperDir '{{ justfile_directory() }}/.scripts/helper' \
        -Bootstrap

restore-selected $MODULES="":
    & '{{ source_directory() }}/run-selected.ps1' \
        -Action restore \
        -Selected $env:MODULES \
        -HelperDir '{{ justfile_directory() }}/.scripts/helper'

record-selected $MODULES="":
    & '{{ source_directory() }}/run-selected.ps1' \
        -Action record \
        -Selected $env:MODULES \
        -HelperDir '{{ justfile_directory() }}/.scripts/helper'

undeploy:
    & '{{ source_directory() }}/undeploy.ps1' '{{ justfile_directory() }}'
