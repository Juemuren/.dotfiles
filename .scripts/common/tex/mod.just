set default-list := true
set default-script := true

[unix]
set script-interpreter := ["sh", "-eu"]

[windows]
set script-interpreter := ["pwsh", "-NoProfile", "-File"]

record os=os():
    tlmgr info --list --only-installed --data name > "{{ justfile_directory() }}/tex/{{ os }}/packages.txt"

[unix]
restore os=os():
    ./restore.sh "{{ justfile_directory() }}/tex/{{ os }}/packages.txt"

[windows]
restore os=os():
    ./restore.ps1 "{{ justfile_directory() }}/tex/{{ os }}/packages.txt"
