# Optional --argjson parameters: sample_size (default 3), key_limit (default 30).
type,
if type == "array" then
  {
    length: length,
    types: ([.[] | type] | unique),
    sample: .[0:($ARGS.named.sample_size // 3)]
  }
elif type == "object" then
  {
    keys: keys[0:($ARGS.named.key_limit // 30)]
  }
else
  .
end
