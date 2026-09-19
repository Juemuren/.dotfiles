set default-list := true

mod brew 'brew'
mod dotter 'dotter'

record: brew::record

restore: brew::restore

bootstrap: dotter::bootstrap
