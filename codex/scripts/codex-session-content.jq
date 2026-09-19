select(.type == "response_item" and .payload.type == "message")
| if .payload.role == "user" then
  "---\n# User\n---\n\n"
elif .payload.role == "assistant" then
  "---\n# Assistant\n---\n\n"
else
  empty
end
+ ([.payload.content[]? | .text // empty] | join("\n"))
+ "\n"
