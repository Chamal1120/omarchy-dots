-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Ctrl+F opens tsesh. Inside tmux it runs in a new window, which closes itself
-- when tsesh exits. This replaces Neovim's default page-forward on this key.
vim.keymap.set("n", "<C-f>", function()
  local tsesh = vim.fn.expand("~/.local/scripts/tsesh")
  if vim.env.TMUX then
    vim.fn.system({ "tmux", "new-window", tsesh })
  else
    vim.cmd.terminal(tsesh)
    vim.cmd.startinsert()
  end
end, { desc = "Switch project (tsesh)" })
