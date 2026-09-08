{
  recommendations: [
    .extensions |
    fromjson |
    .[] |
    select(.applicationScoped == false and .identifier.id != "github.copilot-chat") |
    .identifier.id
  ]
}
