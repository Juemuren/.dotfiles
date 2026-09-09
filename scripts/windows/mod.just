set script-interpreter := ["pwsh", "-NoProfile", "-File"]
set default-script := true
set default-list := true

install:
    ./install.ps1 -Destination '{{ justfile_directory() }}/bin'

update-scoop:
    ./update-scoop.ps1 -Destination '{{ justfile_directory() }}/scoop/buckets'

install-scoop:
    ./install-scoop.ps1 -Source '{{ justfile_directory() }}/scoop/buckets'

record-pwsh:
    ./record-pwsh.ps1 -Destination '{{ justfile_directory() }}/pwsh/modules.txt'

restore-pwsh:
    ./restore-pwsh.ps1 -Source '{{ justfile_directory() }}/pwsh/modules.txt'

[script("msys2")]
update-msys:
    pacman -Qeq > "{{ justfile_directory() }}/msys/packages.txt"
