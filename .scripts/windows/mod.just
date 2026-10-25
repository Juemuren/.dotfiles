set default-list := true
set shell := ["pwsh", "-NoProfile", "-Command"]

bootstrap: env

env:
    & '{{ source_directory() }}/env.ps1'

undeploy:
    & '{{ source_directory() }}/undeploy.ps1' '{{ justfile_directory() }}'
