set default-list
set dotenv-load := true
set dotenv-path := ".restore.local.env"

mod tex 'tex'
mod vscode 'vscode'

[windows]
mod msvc 'msvc'
[windows]
mod wsl 'wsl'
[windows]
mod scoop 'scoop'
[windows]
mod pwsh 'pwsh'
[windows]
mod msys 'msys'

[unix]
mod brew 'brew'

[windows]
mod windows '.scripts/windows'
[unix]
mod unix '.scripts/unix'

mod checks '.scripts/checks'

[windows]
record *modules: (windows::record-selected modules)

[unix]
record *modules: (unix::record-selected modules)

[windows]
restore *modules: (windows::restore-selected modules)

[unix]
restore *modules: (unix::restore-selected modules)

[windows]
bootstrap: windows::bootstrap

[unix]
bootstrap: unix::bootstrap

preview:
    mise dot diff | delta

deploy:
    mise dot apply --force --yes

[windows]
undeploy: windows::undeploy

[unix]
undeploy:
    mise dot unapply
