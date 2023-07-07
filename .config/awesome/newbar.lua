local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local widgets = require("widgets")

local M = {}

local default_args = {

}

local default_spacing = 10

local colors = require("colors")

local status_items = wibox.widget({
  layout = wibox.layout.fixed.horizontal,
  spacing_widget = {
    widget = wibox.widget.separator,
  },
  spacing = beautiful.separator_spacing or default_spacing,
  {
    widget = wibox.container.margin,
    margins = 5,
    {
      widget = wibox.widget.systray
    },
  },
  {
    widget = widgets.volume,
  },
  widgets.keyboardlayout(),
  {
    widget = widgets.icon_text,
    icon = "󰅐 ",
    spacing = -4,
    text_widget = {
      widget = wibox.widget.textclock,
      format = "%m/%d %H:%M"
    }
  },
  {
    widget = widgets.newbattery,
    battery = "BAT0"
  },
  {
    widget = widgets.newbattery,
    battery = "BAT1"
  },
})

setmetatable(M, {
  __call = function(self, args)
    local bar = awful.wibar(
      gears.table.crush(gears.table.clone(default_args), args or {})
    )
    bar:setup({
      layout = wibox.layout.align.horizontal,
      expand = "outside",
      {
        widget = require("widgets.taglist")({
          screen = args.screen
        }),
      },
      {
        widget = widgets.title,
      },
      {
        layout = wibox.layout.align.horizontal,
        [3] = status_items
      }
    })
    return bar
  end
})

return M
