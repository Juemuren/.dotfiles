local map = vim.keymap.set

local vscode = require("vscode")

local function action(name)
  return function()
    vscode.action(name)
  end
end

-- Workbench panels
map("n", "<leader>p", action("workbench.action.quickOpen"), {
  desc = "Quick Open"
})

map("n", "<leader>t", action("workbench.action.tasks.runTask"), {
  desc = "Select a Task"
})

map("n", "<leader>d", action("workbench.action.debug.selectandstart"), {
  desc = "Select a Debug"
})

map("n", "<leader>/", action("workbench.action.findInFiles"), {
  desc = "Find in Files"
})

map("n", "<leader>e", action("workbench.view.explorer"), {
  desc = "Explorer"
})

-- Code actions
map("n", "<leader>r", action("editor.action.rename"), {
  desc = "Rename Symbol"
})

map("n", "<leader>a", action("editor.action.quickFix"), {
  desc = "Code Action"
})

map("n", "<leader>f", action("editor.action.formatDocument"), {
  desc = "Format File"
})
