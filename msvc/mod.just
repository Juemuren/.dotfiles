set default-list := true
set shell := ["pwsh", "-NoProfile", "-Command"]

[script("powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File")]
install:
    & '{{ source_directory() }}/automation/install.ps1'

configure:
    & '{{ source_directory() }}/automation/configure.ps1'

restore:
    & '{{ source_directory() }}/automation/restore.ps1' -ConfigPath '{{ source_directory() }}/.vsconfig'
