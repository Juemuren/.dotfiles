set default-list := true
set shell := ["pwsh", "-NoProfile", "-Command"]

record:
    & '{{ source_directory() }}/automation/record.ps1' -Destination '{{ source_directory() }}/modules.txt'

restore:
    & '{{ source_directory() }}/automation/restore.ps1' -Source '{{ source_directory() }}/modules.txt'
