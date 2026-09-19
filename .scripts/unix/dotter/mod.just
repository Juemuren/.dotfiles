set script-interpreter := ["sh", "-eu"]
set default-script := true
set default-list := true

bootstrap:
    ./bootstrap.sh "{{ justfile_directory() }}/bin"
