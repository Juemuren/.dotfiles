map(
  select(.metadata.isApplicationScoped == true)
  | .identifier.id
)
| sort[]
