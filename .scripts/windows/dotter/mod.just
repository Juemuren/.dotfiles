set script-interpreter := ["pwsh", "-NoProfile", "-File"]
set default-script := true
set default-list := true

bootstrap:
    ./bootstrap.ps1 -Destination '{{ justfile_directory() }}/bin'
