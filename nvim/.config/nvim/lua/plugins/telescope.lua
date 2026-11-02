-- Ctrl+P finds files by name and Ctrl+Space searches file contents. Telescope is
-- added on its own, so LazyVim's default picker still serves its leader keys.
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<C-Space>", "<cmd>Telescope live_grep<cr>", desc = "Search file contents" },
    },
  },
  -- Flash uses Ctrl+Space for treesitter selection. Free it in normal mode only.
  {
    "folke/flash.nvim",
    keys = {
      { "<c-space>", false, mode = "n" },
    },
  },
}
