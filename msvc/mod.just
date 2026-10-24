set script-interpreter := ["pwsh", "-NoProfile", "-File"]
set default-script := true
set default-list := true

bootstrap:
    & '{{ source_directory() }}/automation/bootstrap/index.ps1'
