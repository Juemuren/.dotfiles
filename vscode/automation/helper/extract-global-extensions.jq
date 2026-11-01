map(
  select(.metadata.isApplicationScoped == true and .metadata.source == "gallery")
  | .identifier.id
)
| sort[]
