set script-interpreter := ["pwsh", "-NoProfile", "-File"]
set default-script := true
set default-list := true

install:
    ./install.ps1 -Destination '{{ justfile_directory() }}/bin'

record-scoop:
    ./record-scoop.ps1 -Destination '{{ justfile_directory() }}/scoop/buckets'

restore-scoop:
    ./restore-scoop.ps1 -Source '{{ justfile_directory() }}/scoop/buckets'

record-pwsh:
    ./record-pwsh.ps1 -Destination '{{ justfile_directory() }}/pwsh/modules.txt'

restore-pwsh:
    ./restore-pwsh.ps1 -Source '{{ justfile_directory() }}/pwsh/modules.txt'

[script("msys2")]
record-msys:
    pacman -Qeq > "{{ justfile_directory() }}/msys/packages.txt"

[script("msys2")]
restore-msys:
    xargs pacman -S --needed --noconfirm < "{{ justfile_directory() }}/msys/packages.txt"
