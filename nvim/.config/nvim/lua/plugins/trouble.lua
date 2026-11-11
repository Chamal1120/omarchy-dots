-- Highlight the Trouble list entry for the diagnostic under the cursor.
-- Trouble's `follow` already moves its cursor to that entry, but the aether theme
-- leaves CursorLine empty, so the line was invisible. Use Visual (the theme's
-- selection color) for the cursorline inside Trouble windows only.
--
-- Themes also paint Trouble's window a solid sidebar colour (TroubleNormal),
-- which hides the terminal's see-through background that the rest of the editor
-- shows. Clear that background each time a colorscheme loads, keeping its text
-- colour.
local function clear_trouble_bg()
  for _, group in ipairs({ "TroubleNormal", "TroubleNormalNC" }) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    hl.bg = nil
    hl.ctermbg = nil
    vim.api.nvim_set_hl(0, group, hl)
  end
end

return {
  "folke/trouble.nvim",
  init = function()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("trouble_see_through", { clear = true }),
      callback = clear_trouble_bg,
    })
    clear_trouble_bg()
  end,
  opts = {
    follow = true,
    win = {
      wo = {
        winhighlight = "Normal:TroubleNormal,NormalNC:TroubleNormalNC,EndOfBuffer:TroubleNormal,CursorLine:Visual",
      },
    },
  },
}
