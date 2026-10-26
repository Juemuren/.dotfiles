set default-list := true
set shell := ["pwsh", "-NoProfile", "-Command"]

[script("powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File")]
install:
    & '{{ source_directory() }}/automation/install.ps1'

record:
    & '{{ source_directory() }}/automation/record.ps1' -Destination '{{ source_directory() }}/distributions.txt'

restore:
    & '{{ source_directory() }}/automation/restore.ps1' -Source '{{ source_directory() }}/distributions.txt'
