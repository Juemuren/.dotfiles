set script-interpreter := ["pwsh", "-NoProfile", "-File"]
set default-script := true
set default-list := true

install:
    ./scripts/install.ps1

update-scoop:
    ./scripts/update-scoop.ps1

[script("msys2")]
update-msys:
    pacman -Qeq > "msys/packages.txt"
