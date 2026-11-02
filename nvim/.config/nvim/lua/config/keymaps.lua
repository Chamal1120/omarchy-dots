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

-- LSP navigation on the leader. <leader>gd replaces LazyVim's Git Diff (hunks),
-- which moves to <leader>gv.
vim.keymap.set("n", "<leader>gd", function()
  Snacks.picker.lsp_definitions()
end, { desc = "Goto Definition" })
vim.keymap.set("n", "<leader>gr", function()
  Snacks.picker.lsp_references()
end, { desc = "Goto References" })
vim.keymap.set("n", "<leader>gv", function()
  Snacks.picker.git_diff()
end, { desc = "Git Diff (hunks)" })
