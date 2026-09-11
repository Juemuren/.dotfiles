# application-scoped extensions in the default profile take precedence.
($global_extensions[0]
  | map(select(.metadata.isApplicationScoped == true) | .identifier.id)
) as $global_ids
# which can be incorrectly listed as a profile extension.
| ["github.copilot-chat"] as $ignored_ids
| .[]
| select(.metadata.isApplicationScoped != true)
| .identifier.id as $id
| select($ignored_ids | index($id) == null)
| select($global_ids | index($id) == null)
| $id
