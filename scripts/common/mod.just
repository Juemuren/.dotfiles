set default-list := true
set default-script := true

[unix]
set script-interpreter := ["sh", "-eu"]

[windows]
set script-interpreter := ["pwsh", "-NoProfile", "-File"]

record-tex os:
    tlmgr info --list --only-installed --data name > "{{ justfile_directory() }}/tex/{{ os }}/packages.txt"

[unix]
restore-tex os:
    ./restore-tex.sh "{{ justfile_directory() }}/tex/{{ os }}/packages.txt"

[windows]
restore-tex os:
    ./restore-tex.ps1 "{{ justfile_directory() }}/tex/{{ os }}/packages.txt"
