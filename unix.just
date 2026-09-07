set script-interpreter := ["sh", "-eu"]
set default-script := true
set default-list := true

[linux]
install:
    ./scripts/install.sh

[linux]
update-brew os:
    brew list --installed-on-request > "brew/{{ os }}/packages.txt"
