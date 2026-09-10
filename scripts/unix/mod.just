set script-interpreter := ["sh", "-eu"]
set default-script := true
set default-list := true

install:
    ./install.sh "{{ justfile_directory() }}/bin"

record-brew os=os():
    ./record-brew.sh "{{ justfile_directory() }}/brew/{{ os }}"

restore-brew os=os():
    ./restore-brew.sh "{{ justfile_directory() }}/brew/{{ os }}"
