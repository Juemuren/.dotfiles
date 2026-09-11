if not vim.g.vscode then
  return
end

vim.g.mapleader = " "

local vscode = require("vscode")
local map = vim.keymap.set

local function action(name)
  return function()
    vscode.action(name)
  end
end

-- VS Code UI
map("n", "<leader>p", action("workbench.action.quickOpen"),
  { desc = "Quick Open" })

map("n", "<leader>/", action("workbench.action.findInFiles"),
  { desc = "Find in Files" })

map("n", "<leader>e", action("workbench.view.explorer"),
  { desc = "Explorer" })

-- Code actions
map("n", "<leader>r", action("editor.action.rename"),
  { desc = "Rename Symbol" })

map("n", "<leader>a", action("editor.action.quickFix"),
  { desc = "Code Action" })

map("n", "<leader>w", action("workbench.action.files.save"),
  { desc = "Save" })
