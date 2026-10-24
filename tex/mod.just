set default-list := true
set default-script := true

[unix]
set script-interpreter := ["sh", "-eu"]

[windows]
set script-interpreter := ["pwsh", "-NoProfile", "-File"]

record os=os():
    tlmgr info --list --only-installed --data name > "{{ source_directory() }}/{{ os }}/packages.txt"

[unix]
restore os=os():
    "{{ source_directory() }}/automation/restore.sh" "{{ source_directory() }}/{{ os }}/packages.txt"

[windows]
restore os=os():
    & '{{ source_directory() }}/automation/restore.ps1' '{{ source_directory() }}/{{ os }}/packages.txt'
