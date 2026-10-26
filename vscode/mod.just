set default-list := true

configure:
    "{{ source_directory() }}/automation/configure.sh" "{{ source_directory() }}/profiles" "{{ source_directory() }}/mise.local.toml"

record profile="all":
    "{{ source_directory() }}/automation/record.sh" "{{ source_directory() }}/profiles" "{{ profile }}"

restore profile="all":
    "{{ source_directory() }}/automation/restore.sh" "{{ source_directory() }}/profiles" "{{ profile }}"
