set default-list := true
set shell := ["pwsh", "-NoProfile", "-Command"]

bootstrap: env restore-selected

restore-selected:
    & '{{ source_directory() }}/run-selected.ps1' -Action restore -ConfigDir '{{ justfile_directory() }}/.mise' -HelperDir '{{ justfile_directory() }}/.scripts/helper'

record-selected:
    & '{{ source_directory() }}/run-selected.ps1' -Action record -ConfigDir '{{ justfile_directory() }}/.mise' -HelperDir '{{ justfile_directory() }}/.scripts/helper'

env:
    & '{{ source_directory() }}/env.ps1'

undeploy:
    & '{{ source_directory() }}/undeploy.ps1' '{{ justfile_directory() }}'
