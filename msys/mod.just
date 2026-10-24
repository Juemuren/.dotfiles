set default-list := true

[script("msys2")]
record:
    pacman -Qeq > "{{ source_directory() }}/packages.txt"

[script("msys2")]
restore:
    xargs pacman -S --needed --noconfirm < "{{ source_directory() }}/packages.txt"
