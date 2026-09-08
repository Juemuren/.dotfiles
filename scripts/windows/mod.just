set script-interpreter := ["pwsh", "-NoProfile", "-File"]
set default-script := true
set default-list := true

install:
    ./install.ps1 -Destination '{{ justfile_directory() }}/bin'

update-scoop:
    ./update-scoop.ps1 -Destination '{{ justfile_directory() }}/scoop/buckets'

[script("msys2")]
update-msys:
    pacman -Qeq > "{{ justfile_directory() }}/msys/packages.txt"
