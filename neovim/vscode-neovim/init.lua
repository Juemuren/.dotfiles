if not vim.g.vscode then
  return
end

vim.g.mapleader = " "

require("config.options")
require("config.keymaps")
