local awful = require("awful")
local tag = require("awful.tag")
local layout = require("awful.layout")

layout.layouts = {
  layout.suit.spiral.dwindle,
  layout.suit.tile,
  layout.suit.magnifier,
}

tag({1, 2, 3, 4, 5, 6, 7, 8, 9}, 1, layout.layouts[1])

local tags = root.tags()

for _, t in ipairs(tags) do
  t.gap = 5
end
