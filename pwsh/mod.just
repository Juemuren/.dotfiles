set script-interpreter := ["pwsh", "-NoProfile", "-File"]
set default-script := true
set default-list := true

record:
    & '{{ source_directory() }}/automation/record.ps1' -Destination '{{ source_directory() }}/modules.txt'

restore:
    & '{{ source_directory() }}/automation/restore.ps1' -Source '{{ source_directory() }}/modules.txt'
