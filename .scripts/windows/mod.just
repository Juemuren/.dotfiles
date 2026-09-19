set default-list := true

mod scoop 'scoop'
mod pwsh 'pwsh'
mod msys 'msys'
mod dotter 'dotter'

record: scoop::record pwsh::record msys::record

restore: scoop::restore pwsh::restore msys::restore

bootstrap: dotter::bootstrap
