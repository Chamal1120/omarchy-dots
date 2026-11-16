-- Change the default Omarchy look'n'feel.

-- Drag window borders with the mouse to resize.
hl.config({
  general = {
    resize_on_border = true,
  },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- hl.config({
--   general = {
--     -- No gaps between windows or borders.
--     gaps_in = 0,
--     gaps_out = 0,
--     border_size = 0,
--
--     -- Change to niri-like side-scrolling layout.
--     layout = "scrolling",
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
-- hl.config({
--   decoration = {
--     -- Use round window corners.
--     rounding = 8,
--
--     -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
--     dim_inactive = true,
--     dim_strength = 0.15,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })

-- Opt another application in to Omarchy's standard transparency.
-- Find its class with: hyprctl clients
-- o.transparent_window("my-app")
-- o.transparent_window("my-app", "0.9 0.85") -- Custom active/inactive opacity.

-- Open the Android emulator as a narrow tiled column instead of a 50/50 split.
-- Dwindle ignores size rules on tiled windows, so set the split ratio when it opens.
local emulator_width = 339 -- logical px

local function size_emulator(window)
  if not window or window.class ~= "Emulator" or window.floating then return end

  local target = "address:" .. window.address
  hl.timer(function()
    local w = hl.get_window(target)
    if not w or w.floating then return end

    local others = 0
    for _, c in ipairs(hl.get_windows and hl.get_windows() or {}) do
      if c.workspace and w.workspace and c.workspace.id == w.workspace.id and not c.floating and c.address ~= w.address then
        others = others + 1
      end
    end
    if hl.get_windows and others == 0 then return end

    -- At the default ratio the two halves are equal, so the split node is twice this window plus its gap.
    local gap = 7
    local node = 2 * (w.size.x + gap)
    local is_right = w.at and w.at.x and w.at.x > (w.monitor and w.monitor.position.x or 0) + 50
    local function ratio_for(width)
      if is_right then return 2 * (node - gap - width) / node end
      return 2 * (width + gap) / node
    end

    hl.dispatch(hl.dsp.focus({ window = target }))
    local r = ratio_for(emulator_width)
    hl.dispatch(hl.dsp.layout(string.format("splitratio %.4f exact", r)))

    -- Correct once for any difference in gaps or borders.
    local after = hl.get_window(target)
    if after and after.size.x ~= emulator_width then
      local step = 2 * (after.size.x - emulator_width) / node
      r = is_right and r + step or r - step
      hl.dispatch(hl.dsp.layout(string.format("splitratio %.4f exact", r)))
    end
  end, { timeout = 50, type = "oneshot" })
end

hl.on("window.open", size_emulator)
