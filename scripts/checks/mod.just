set default-list := true

mod pwsh 'pwsh'
mod sh 'sh'
mod py 'py'

fmt: sh::fmt pwsh::fmt py::fmt
    dprint fmt

lint: sh::lint pwsh::lint py::lint
