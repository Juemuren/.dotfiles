set script-interpreter := ["sh", "-eu"]
set default-script := true
set default-list := true

lint:
    fd -e sh -e bash -e zsh -x shellcheck

fmt:
    shfmt --write .
