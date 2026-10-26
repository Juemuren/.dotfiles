set default-list := true
set shell := ["pwsh", "-NoProfile", "-Command"]

[script("powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File")]
bootstrap:
    & '{{ source_directory() }}/automation/bootstrap/index.ps1'

record:
    & '{{ source_directory() }}/automation/record/index.ps1' -Destination '{{ source_directory() }}'

restore:
    & '{{ source_directory() }}/automation/restore/index.ps1' -Source '{{ source_directory() }}'
