set script-interpreter := ["sh", "-eu"]
set default-script := true
set default-list := true

[linux]
install:
    ./install.sh "{{ justfile_directory() }}/bin"

[linux]
update-brew os:
    brew list --installed-on-request > "{{ justfile_directory() }}/brew/{{ os }}/packages.txt"
