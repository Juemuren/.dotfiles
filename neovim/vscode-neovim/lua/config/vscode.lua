local map = vim.keymap.set

local vscode = require("vscode")

local function action(name, opt)
  return function()
    vscode.action(name, opt)
  end
end

-- Select
map("n", "<leader>sp", action("workbench.action.quickOpen", {
  args = { "?" }
}), {
  desc = "Select Picker"
})

map("n", "<leader>sv", action("workbench.action.openView"), {
  desc = "Select View"
})

map("n", "<leader>se", action("workbench.action.showAllEditors"), {
  desc = "Select Editor"
})

map("n", "<leader>st", action("workbench.action.quickOpen", {
  args = { "term " }
}), {
  desc = "Select Terminal"
})

-- Run
map("n", "<leader>rc", action("workbench.action.showCommands"), {
  desc = "Run Command"
})

map("n", "<leader>rt", action("workbench.action.tasks.runTask"), {
  desc = "Run Task"
})

map("n", "<leader>rd", action("workbench.action.debug.selectandstart"), {
  desc = "Run Debug"
})

-- Find
map("n", "<leader>ff", action("workbench.action.quickOpen"), {
  desc = "Find File"
})

map("n", "<leader>ft", action("workbench.action.quickTextSearch"), {
  desc = "Find Text"
})

map("n", "<leader>fs", action("workbench.action.gotoSymbol"), {
  desc = "Find Symbol",
})

map("n", "<leader>fS", action("workbench.action.showAllSymbols"), {
  desc = "Find Workspace Symbol",
})

-- Open View
map("n", "<leader>os", action("workbench.view.search"), {
  desc = "Open Search View"
})

map("n", "<leader>oe", action("workbench.view.explorer"), {
  desc = "Open Explorer View"
})

map("n", "<leader>og", action("workbench.view.scm"), {
  desc = "Open Git View"
})

map("n", "<leader>op", action("workbench.actions.view.problems"), {
  desc = "Open Problem View"
})

map("n", "<leader>oo", action("workbench.action.output.toggleOutput"), {
  desc = "Open Output View"
})

map("n", "<leader>ot", action("workbench.action.terminal.toggleTerminal"), {
  desc = "Open Terminal View"
})

map("n", "<leader>ob", action("workbench.action.browser.open"), {
  desc = "Open Browser View"
})

-- Code Action
map("n", "<leader>cx", action("editor.action.quickFix"), {
  desc = "Code Fix"
})

map("n", "<leader>cf", action("editor.action.formatDocument"), {
  desc = "Code Format"
})

map("n", "<leader>cF", action("editor.action.formatDocument.multiple"), {
  desc = "Code Format with selecting a formatter first"
})
