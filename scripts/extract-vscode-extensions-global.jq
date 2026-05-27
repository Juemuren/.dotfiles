{
  recommendations: [
    .extensions |
    fromjson |
    .[] |
    select(.applicationScoped == true) |
    .identifier.id
  ]
}
