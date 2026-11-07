-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Remove Omarchy's web app launchers. These are unbound one by one because
-- omarchy_preinstalled_bindings = false would also drop Tmux, Signal, Obsidian
-- and the other native apps.
hl.unbind("SUPER + SHIFT + A") -- ChatGPT
hl.unbind("SUPER + SHIFT + ALT + A") -- Grok
hl.unbind("SUPER + SHIFT + C") -- Calendar
hl.unbind("SUPER + SHIFT + E") -- Email
hl.unbind("SUPER + SHIFT + ALT + E") -- New email
hl.unbind("SUPER + SHIFT + Y") -- YouTube
hl.unbind("SUPER + SHIFT + ALT + G") -- WhatsApp
hl.unbind("SUPER + SHIFT + CTRL + G") -- Google Messages
hl.unbind("SUPER + SHIFT + P") -- Google Photos
hl.unbind("SUPER + SHIFT + S") -- Google Maps
hl.unbind("SUPER + SHIFT + X") -- X
hl.unbind("SUPER + SHIFT + ALT + X") -- X Post

-- Open Chrome directly.
hl.unbind("SUPER + SHIFT + RETURN") -- was: Browser
o.bind("SUPER + SHIFT + RETURN", "Chrome", { launch = "google-chrome-stable" })

-- Vim-style window navigation.
-- Free up the defaults that sat on J, K and L (SUPER + H was unbound).
hl.unbind("SUPER + J") -- was: Toggle window split
hl.unbind("SUPER + K") -- was: Keybindings
hl.unbind("SUPER + L") -- was: Toggle workspace layout

-- Displaced defaults, moved to non-vim keys.
o.bind("SUPER + E", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + B", "Keybindings", "omarchy-menu-keybindings")
o.bind("SUPER + M", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

-- Focus windows.
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

-- Swap windows.
o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

-- Resize windows. Hold to keep resizing.
o.bind("ALT + SHIFT + H", "Shrink window width", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
o.bind("ALT + SHIFT + J", "Grow window height", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
o.bind("ALT + SHIFT + K", "Shrink window height", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
o.bind("ALT + SHIFT + L", "Grow window width", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })

-- Toggle floating, and give a newly floated window a sane default size
-- (instead of keeping its tiled size), centered on its monitor.
-- Change these to taste; the size is capped to a share of the monitor.
local FLOAT_WIDTH, FLOAT_HEIGHT = 1100, 760

local function toggle_float()
  local window = hl.get_active_window()
  if not window then
    return
  end

  local was_floating = window.floating
  hl.dispatch(hl.dsp.window.float({ action = "toggle", window = window }))
  if was_floating then
    return
  end

  local width, height = FLOAT_WIDTH, FLOAT_HEIGHT
  local monitor = window.monitor
  if monitor and monitor.width then
    local mw = math.floor(monitor.width / monitor.scale)
    local mh = math.floor(monitor.height / monitor.scale)
    if (monitor.transform or 0) % 2 == 1 then
      mw, mh = mh, mw
    end
    width = math.min(width, math.floor(mw * 0.8))
    height = math.min(height, math.floor(mh * 0.8))
  end

  hl.dispatch(hl.dsp.window.resize({ x = width, y = height, relative = false, window = window }))
  hl.dispatch(hl.dsp.window.center({ window = window }))
end

o.bind_expressions[toggle_float] = 'hl.dsp.window.float({ action = "toggle" })'
o.rebind("SUPER + T", "Toggle window floating/tiling", toggle_float)
