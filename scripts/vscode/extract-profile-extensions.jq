# Profile metadata can be stale; application-scoped extensions in the default
# profile take precedence. Extension IDs are case-insensitive in VSCode.
($global_extensions[0]
| map(select(.metadata.isApplicationScoped == true) | .identifier.id | ascii_downcase)
) as $global_ids
| .[]
| select(.metadata.isApplicationScoped != true and .identifier.id != "github.copilot-chat")
| .identifier.id
| select(ascii_downcase as $id | $global_ids | index($id) == null)
