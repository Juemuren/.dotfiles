set default-list := true
set default-script := true

[unix]
set script-interpreter := ["sh", "-eu"]

[windows]
set script-interpreter := ["pwsh", "-NoProfile", "-File"]

update-tex:
    tlmgr info --list --only-installed --data name > "{{ justfile_directory() }}/tex/{{ os() }}/packages.txt"
