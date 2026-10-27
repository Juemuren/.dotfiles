set default-list

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
record: windows::record-selected

[unix]
record: unix::record-selected

[windows]
restore: windows::restore-selected

[unix]
restore: unix::restore-selected

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
