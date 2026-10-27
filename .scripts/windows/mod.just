set default-list := true
set shell := ["pwsh", "-NoProfile", "-Command"]

bootstrap: env restore-selected

restore-selected:
    & '{{ source_directory() }}/restore-selected.ps1' -ConfigDir '{{ justfile_directory() }}/.mise' -HelperDir '{{ justfile_directory() }}/.scripts/helper'

record-selected:
    & '{{ source_directory() }}/record-selected.ps1' -ConfigDir '{{ justfile_directory() }}/.mise' -HelperDir '{{ justfile_directory() }}/.scripts/helper'

env:
    & '{{ source_directory() }}/env.ps1'

undeploy:
    & '{{ source_directory() }}/undeploy.ps1' '{{ justfile_directory() }}'
