set default-list := true

mod pwsh 'pwsh'
mod msys 'msys'

record: pwsh::record msys::record

restore: pwsh::restore msys::restore

bootstrap:
