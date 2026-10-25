set default-list := true
set shell := ["pwsh", "-NoProfile", "-Command"]

bootstrap:
    & '{{ source_directory() }}/automation/bootstrap/index.ps1'
