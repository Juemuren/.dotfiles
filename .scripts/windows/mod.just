set default-list := true
set script-interpreter := ["pwsh", "-NoProfile", "-File"]
set default-script := true

env:
    & '{{ source_directory() }}/env.ps1'

bootstrap: env
