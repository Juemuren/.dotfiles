set script-interpreter := ["sh", "-eu"]
set default-script := true
set default-list := true

[windows]
bootstrap:
    ./bootstrap.sh "{{ justfile_directory() }}/vscode/profiles" "{{ justfile_directory() }}/.local/vscode.env"

record profile="all":
    ./record/index.sh "{{ justfile_directory() }}/vscode/profiles" "{{ profile }}"

restore profile="all":
    ./restore.sh "{{ justfile_directory() }}/vscode/profiles" "{{ profile }}"
