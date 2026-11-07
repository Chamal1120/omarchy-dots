-- Hide inline diagnostic messages (virtual text). Signs and underlines remain;
-- use <leader>cd to show the current line's diagnostics.
return {
  "neovim/nvim-lspconfig",
  opts = {
    diagnostics = {
      virtual_text = false,
    },
  },
}
