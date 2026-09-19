[
  .[]
  | select(.type == "match")
  | select(
    .data.lines.text
    | fromjson
    | .type == "response_item"
      and .payload.type == "message"
      and (.payload.role == "user" or .payload.role == "assistant")
  )
  | .data.path.text
]
| unique[]
