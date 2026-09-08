set script-interpreter := ["pwsh", "-NoProfile", "-File"]
set default-script := true
set default-list := true

update:
    ./update.ps1 -Destination '{{ justfile_directory() }}/pwsh/modules.txt'

lint:
    Set-Location -LiteralPath '{{ justfile_directory() }}'
    fd -e ps1 -e psm1 -e psd1 | Run-Lint.ps1

fmt:
    Set-Location -LiteralPath '{{ justfile_directory() }}'
    fd -e ps1 -e psm1 -e psd1 | Run-Format.ps1
