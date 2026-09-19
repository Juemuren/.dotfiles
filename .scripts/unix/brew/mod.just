set script-interpreter := ["sh", "-eu"]
set default-script := true
set default-list := true

record os=os():
    ./record.sh "{{ justfile_directory() }}/brew/{{ os }}"

restore os=os():
    ./restore.sh "{{ justfile_directory() }}/brew/{{ os }}"
