set default-list := true
set shell := ["pwsh", "-NoProfile", "-Command"]

configure:
    & '{{ source_directory() }}/automation/configure.ps1'

record:
    & '{{ source_directory() }}/automation/record/index.ps1' -Destination '{{ source_directory() }}'

restore:
    & '{{ source_directory() }}/automation/restore/index.ps1' -Source '{{ source_directory() }}'
