local map = vim.keymap.set

-- Delete

map({ "n", "x" }, "x", '"_x', {
  desc = "Delete character without overwriting clipboard",
})

map({"n", "x"}, "<leader>d", '"_d', {
  desc = "Delete without overwriting clipboard",
})

-- Paste

map("x", "p", '"_dP', {
  desc = "Paste without overwriting clipboard",
})

map({"n", "x"}, "<leader>p", '"0p', {
  desc = "Paste last yanked text",
})

map("n", "<leader>P", '"0P', {
  desc = "Paste last yanked text before cursor",
})

