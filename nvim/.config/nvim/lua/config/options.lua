-- Options are automatically loaded before lazy.nvim startup.
require("config.remote_clipboard").setup()

vim.opt.relativenumber = true
vim.g.autoformat = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.listchars = { tab = "  ", nbsp = "+" } -- Blank tab marker, no ">" in indents.
