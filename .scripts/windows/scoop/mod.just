set script-interpreter := ["pwsh", "-NoProfile", "-File"]
set default-script := true
set default-list := true

record:
    ./record/index.ps1 -Destination '{{ justfile_directory() }}/scoop'

restore:
    ./restore/index.ps1 -Source '{{ justfile_directory() }}/scoop'
