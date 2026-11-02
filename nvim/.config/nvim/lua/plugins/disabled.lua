-- Turn off Neo-tree (the side tree) and Bufferline (the file names along the top).
-- Also turn off LSP inlay hints (the types shown as virtual text inside the code).
return {
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  { "akinsho/bufferline.nvim", enabled = false },
  { "neovim/nvim-lspconfig", opts = { inlay_hints = { enabled = false } } },
}
