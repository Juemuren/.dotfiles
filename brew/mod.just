set script-interpreter := ["sh", "-eu"]
set default-script := true
set default-list := true

record os=os():
    "{{ source_directory() }}/automation/record.sh" "{{ source_directory() }}/{{ os }}"

restore os=os():
    "{{ source_directory() }}/automation/restore.sh" "{{ source_directory() }}/{{ os }}"
