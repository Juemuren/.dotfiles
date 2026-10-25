set default-list := true

[windows]
set shell := ["pwsh", "-NoProfile", "-Command"]

record os=os():
    tlmgr info --list --only-installed --data name > "{{ source_directory() }}/{{ os }}/packages.txt"

[unix]
restore os=os():
    "{{ source_directory() }}/automation/restore.sh" "{{ source_directory() }}/{{ os }}/packages.txt"

[windows]
restore os=os():
    & '{{ source_directory() }}/automation/restore.ps1' '{{ source_directory() }}/{{ os }}/packages.txt'
