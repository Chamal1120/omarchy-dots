-- _ opens the current file's folder in Oil. This replaces Vim's _ motion in normal
-- mode. Oil also handles `nvim <folder>`, which needs it loaded at startup.
return {
  "stevearc/oil.nvim",
  lazy = false,
  keys = {
    { "_", "<cmd>Oil<cr>", desc = "Open Oil" },
  },
  opts = {},
}
