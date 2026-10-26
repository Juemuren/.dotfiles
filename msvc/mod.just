set default-list := true
set shell := ["pwsh", "-NoProfile", "-Command"]

install:
    & '{{ source_directory() }}/automation/install.ps1' -ConfigPath '{{ source_directory() }}/.vsconfig'

configure:
    & '{{ source_directory() }}/automation/configure.ps1'
