set script-interpreter := ["sh", "-eu"]
set default-script := true
set default-list := true

update profile:
    ./update.sh "{{ justfile_directory() }}/vscode/profiles" "{{ profile }}"
