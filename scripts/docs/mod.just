set script-interpreter := ["sh", "-eu"]
set default-script := true
set default-list := true

update:
    ./update.sh "{{ justfile_directory() }}"
