set default-list := true

[script("msys2")]
record:
    pacman -Qeq > "{{ justfile_directory() }}/msys/packages.txt"

[script("msys2")]
restore:
    xargs pacman -S --needed --noconfirm < "{{ justfile_directory() }}/msys/packages.txt"
