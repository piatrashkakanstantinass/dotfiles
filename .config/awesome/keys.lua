local awful = require("awful")
local gears = require("gears")

local key = awful.key

local mod = "Mod4"
local ctrl = "Control"
local shift = "Shift"

local term = "alacritty"

local tagkeys = {}
for i = 1, 9 do
  tagkeys = gears.table.join(tagkeys,
    key({ mod }, "#" .. i + 9, function() awful.screen.focused().tags[i]:view_only() end),
    key({mod, shift}, "#" .. i + 9, function() local client = client.focus; if not client then return end client:move_to_tag(awful.screen.focused().tags[i]) end),
    key({mod, ctrl}, "#" .. i + 9, function() awful.tag.viewtoggle(awful.screen.focused().tags[i]) end)
  )
end

local change_global_gaps = function(i)
  for _, t in ipairs(root.tags()) do
    t.gap = t.gap + i
  end
end

root.keys(gears.table.join(table.unpack({

  -- WM keys
  key({mod, ctrl}, "r", awesome.restart),
  key({mod, shift}, "q", awesome.quit),

  -- Brightness, volume control
  key({}, "XF86MonBrightnessUp", function() awful.spawn({"brightnessctl", "s", "10%+"}, false) end),
  key({}, "XF86MonBrightnessDown", function() awful.spawn({"brightnessctl", "s", "10%-"}, false) end),
  key({}, "XF86AudioRaiseVolume", function() awful.spawn({"pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%"}, false) end),
  key({}, "XF86AudioLowerVolume", function() awful.spawn({"pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%"}, false) end),
  key({}, "XF86AudioMute", function() awful.spawn({"pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle"}, false) end),

  -- Tags
  tagkeys,
  key({mod}, "Tab", function() awful.tag.history.restore(awful.screen.focused()) end),
  key({mod, ctrl}, "=", function() change_global_gaps(2) end),
  key({mod, ctrl}, "-", function() change_global_gaps(-2) end),
  key({mod}, "h", function() awful.tag.incmwfact(-0.05) end),
  key({mod}, "l", function() awful.tag.incmwfact(0.05) end),
  key({mod, shift}, "h", function() awful.tag.incnmaster(1) end),
  key({mod, shift}, "l", function() awful.tag.incnmaster(-1) end),
  key({mod, ctrl}, "h", function() awful.tag.incncol(1) end),
  key({mod, ctrl}, "l", function() awful.tag.incncol(-1) end),
  key({mod}, "space", function() awful.layout.inc(1) end),
  key({mod, shift}, "space", function() awful.layout.inc(-1) end),

  -- Client keys
  key({mod, shift}, "c", function() return client.focus and client.focus:kill() end),
  key({mod}, "j", function()
    if not client.focus or client.focus.maximized then return end
    awful.client.focus.byidx(1)
  end),
  key({mod}, "k", function()
    if not client.focus or client.focus.maximized then return end
    awful.client.focus.byidx(-1)
  end),
  key({mod, shift}, "j", function()
    if not client.focus then return end
    awful.client.swap.byidx(1)
  end),
  key({mod, shift}, "k", function()
    if not client.focus then return end
    awful.client.swap.byidx(-1)
  end),
  key({mod}, "m", function() local client = client.focus; client.maximized = not client.maximized end),
  key({mod, ctrl}, "space", function() local client = client.focus; client.floating = not client.floating end),
  key({mod, ctrl}, "Return", function()
    local client = client.focus
    if not client then return end
    client:swap(awful.client.getmaster())
  end),
  key({ mod, shift }, "Return", function() awful.client.focus.byidx(0, awful.client.getmaster()) end),

  -- Spawn keys
  key({mod}, "Return", function() awful.spawn(term) end),
  key({mod}, "p", function() awful.spawn({"rofi", "-show", "drun", "-dpi", "120"}, false) end),

})))

root.buttons(gears.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
