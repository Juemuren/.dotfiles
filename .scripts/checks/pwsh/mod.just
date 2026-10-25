set default-list := true
set shell := ["pwsh", "-NoProfile", "-Command"]

lint:
    Set-Location -LiteralPath '{{ justfile_directory() }}' && \
    fd -e ps1 -e psm1 -e psd1 | Run-Lint.ps1

fmt:
    Set-Location -LiteralPath '{{ justfile_directory() }}' && \
    fd -e ps1 -e psm1 -e psd1 | Run-Format.ps1
