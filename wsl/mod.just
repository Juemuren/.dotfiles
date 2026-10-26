set default-list := true
set shell := ["pwsh", "-NoProfile", "-Command"]

install:
    & '{{ source_directory() }}/automation/install.ps1'
