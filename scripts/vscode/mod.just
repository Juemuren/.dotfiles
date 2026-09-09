set script-interpreter := ["sh", "-eu"]
set default-script := true
set default-list := true

record profile:
    ./record.sh "{{ justfile_directory() }}/vscode/profiles" "{{ profile }}"
