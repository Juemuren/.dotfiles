set script-interpreter := ["pwsh", "-NoProfile", "-File"]
set default-script := true
set default-list := true

record:
    & '{{ source_directory() }}/automation/record/index.ps1' -Destination '{{ source_directory() }}'

restore:
    & '{{ source_directory() }}/automation/restore/index.ps1' -Source '{{ source_directory() }}'
