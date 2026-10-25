set default-list := true
set script-interpreter := ["pwsh", "-NoProfile", "-File"]
set default-script := true

bootstrap: env

env:
    & '{{ source_directory() }}/env.ps1'

undeploy:
    & '{{ source_directory() }}/undeploy.ps1' '{{ justfile_directory() }}'
