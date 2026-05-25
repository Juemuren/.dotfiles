{
  recommendations: [
    .extensions |
    fromjson |
    .[] |
    select(.applicationScoped == false) |
    .identifier.id
  ]
}
