set script-interpreter := ["pwsh", "-NoProfile", "-File"]
set default-script := true
set default-list := true

update:
    ./scripts/update-pwsh.ps1

lint:
    fd -e ps1 -e psm1 -e psd1 | ./pwsh/scripts/Run-Lint.ps1

fmt:
    fd -e ps1 -e psm1 -e psd1 | ./pwsh/scripts/Run-Format.ps1
