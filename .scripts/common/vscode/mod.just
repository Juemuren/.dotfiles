set script-interpreter := ["sh", "-eu"]
set default-script := true
set default-list := true

record profile="all":
    ./record/index.sh "{{ justfile_directory() }}/vscode/profiles" "{{ profile }}"

restore profile="all":
    ./restore.sh "{{ justfile_directory() }}/vscode/profiles" "{{ profile }}"
