set default-list := true

mod docs 'docs'
mod pwsh 'pwsh'
mod sh 'sh'
mod py 'py'

fmt: sh::fmt pwsh::fmt py::fmt
    cd "{{ justfile_directory() }}" && dprint fmt

lint: sh::lint pwsh::lint py::lint
