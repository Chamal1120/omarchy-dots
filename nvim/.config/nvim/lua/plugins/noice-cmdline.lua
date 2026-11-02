-- Type commands on the bottom line, like stock Vim, instead of in a centered popup.
-- Noice keeps the cmdline while its messages UI is on, so this switches the view.
local plain = { icon = false, conceal = false }

return {
  "folke/noice.nvim",
  opts = {
    cmdline = {
      view = "cmdline",
      format = {
        cmdline = plain,
        search_down = plain,
        search_up = plain,
        filter = plain,
        lua = plain,
        help = plain,
      },
    },
  },
}
