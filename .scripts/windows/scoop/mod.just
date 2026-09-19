set script-interpreter := ["pwsh", "-NoProfile", "-File"]
set default-script := true
set default-list := true

record:
    ./record.ps1 -Destination '{{ justfile_directory() }}/scoop/buckets'

restore:
    ./restore.ps1 -Source '{{ justfile_directory() }}/scoop/buckets'
