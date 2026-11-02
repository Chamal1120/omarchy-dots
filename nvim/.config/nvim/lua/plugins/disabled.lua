-- Turn off Neo-tree (the side tree), Bufferline (the file names along the top), and
-- which-key (the guide that pops up after pressing keys like v, y, or leader).
-- Also turn off LSP inlay hints (the types shown as virtual text inside the code).
return {
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  { "akinsho/bufferline.nvim", enabled = false },
  { "folke/which-key.nvim", enabled = false },
  { "neovim/nvim-lspconfig", opts = { inlay_hints = { enabled = false } } },
}
