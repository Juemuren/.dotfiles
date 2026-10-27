set default-list := true
set shell := ["pwsh", "-NoProfile", "-Command"]

[script("powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File")]
install:
    & '{{ source_directory() }}/automation/install.ps1'

configure-machine-env:
    & '{{ source_directory() }}/automation/configure-machine-env.ps1'

record:
    & '{{ source_directory() }}/automation/record/index.ps1' -Destination '{{ source_directory() }}'

restore: configure-machine-env
    & '{{ source_directory() }}/automation/restore/index.ps1' -Source '{{ source_directory() }}'
