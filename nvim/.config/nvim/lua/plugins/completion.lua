-- Completion only appears on request. Alt+I toggles the menu, and Ctrl+N and Ctrl+P
-- move through it. Ghost text is off too, since it would still show while typing.
return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      menu = { auto_show = false },
      ghost_text = { enabled = false },
    },
    keymap = {
      ["<A-i>"] = {
        function(cmp)
          if cmp.is_menu_visible() then
            cmp.hide()
          else
            cmp.show()
          end
          return true
        end,
      },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
    },
  },
}
