vim.opt.clipboard = "unnamedplus"

if vim.fn.has("win32") == 1 then
  vim.opt.shell = "sh"
  vim.opt.shellcmdflag = "-c"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
  vim.opt.shellslash = true
end
