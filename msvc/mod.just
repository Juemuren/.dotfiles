set default-list := true
set shell := ["pwsh", "-NoProfile", "-Command"]

[script("powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File")]
install:
    & '{{ source_directory() }}/automation/install.ps1'

configure-machine-env:
    & '{{ source_directory() }}/automation/configure-machine-env.ps1'

record:

restore:
    & '{{ source_directory() }}/automation/restore.ps1' -ConfigPath '{{ source_directory() }}/.vsconfig'
