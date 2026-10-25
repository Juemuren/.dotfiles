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
record: pwsh::record msys::record tex::record scoop::record vscode::record

[unix]
record: brew::record tex::record vscode::record

[windows]
restore: scoop::restore pwsh::restore msys::restore tex::restore vscode::restore

[unix]
restore: brew::restore tex::restore vscode::restore

[windows]
bootstrap: windows::bootstrap restore-selected

[unix]
bootstrap: unix::bootstrap restore-selected

[windows]
restore-selected:
    & '{{ justfile_directory() }}/.scripts/windows/restore-selected.ps1'

[unix]
restore-selected:
    '{{ justfile_directory() }}/.scripts/unix/restore-selected.sh'

preview:
    mise dot diff | delta

deploy:
    mise dot apply --force --yes

[windows]
undeploy: windows::undeploy

[unix]
undeploy:
    mise dot unapply
