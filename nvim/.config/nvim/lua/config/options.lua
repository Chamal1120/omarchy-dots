-- Options are automatically loaded before lazy.nvim startup.
require("config.remote_clipboard").setup()

vim.opt.relativenumber = false
vim.g.autoformat = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.listchars = { tab = "  ", trail = "-", nbsp = "+" } -- Blank tab marker, no ">" in indents.
