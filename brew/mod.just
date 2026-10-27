set default-list := true

install:
    bash "{{ source_directory() }}/automation/install.sh"

record os=os():
    "{{ source_directory() }}/automation/record.sh" "{{ source_directory() }}/{{ os }}"

restore os=os():
    "{{ source_directory() }}/automation/restore.sh" "{{ source_directory() }}/{{ os }}"
