set default-list := true

[script("bash")]
bootstrap prefix:
    "{{ source_directory() }}/automation/bootstrap.sh" "{{ prefix }}"

record os=os():
    "{{ source_directory() }}/automation/record.sh" "{{ source_directory() }}/{{ os }}"

restore os=os():
    "{{ source_directory() }}/automation/restore.sh" "{{ source_directory() }}/{{ os }}"
