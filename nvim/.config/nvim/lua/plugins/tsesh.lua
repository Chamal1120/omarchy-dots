-- Free Ctrl+F in normal mode for tsesh (see config/keymaps.lua). LazyVim's Noice
-- binds it to scroll hover docs and would otherwise win. Insert mode keeps it.
return {
  "folke/noice.nvim",
  keys = {
    { "<c-f>", false, mode = "n" },
  },
}
