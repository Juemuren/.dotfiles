set script-interpreter := ["sh", "-eu"]
set default-script := true
set default-list := true

lint:
    cd "{{ justfile_directory() }}"
    ruff check .
    ty check .

fmt:
    cd "{{ justfile_directory() }}"
    ruff format .
