set default-list := true

mod vscode "vscode"
mod tex "tex"

record: vscode::record tex::record

restore: vscode::restore tex::restore
