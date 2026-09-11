set script-interpreter := ["sh", "-eu"]
set default-script := true
set default-list := true

lint:
    cd "{{ justfile_directory() }}"
    fd -e sh -e bash -e zsh -x shellcheck

fmt:
    cd "{{ justfile_directory() }}"
    shfmt --write .
