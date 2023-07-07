local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local colors  =require("colors")

local font="JetBrainsMono Nerd Font 11"

local taglist_buttons = gears.table.join(table.unpack({
  awful.button({}, 1, function(t) t:view_only() end),
  awful.button({}, 4, function(t) awful.tag.viewnext() end),
  awful.button({}, 5, function(t) awful.tag.viewprev() end),
}))

local taglist = awful.widget.taglist({
  screen = awful.screen.focused(),
  filter = awful.widget.taglist.filter.all,
  buttons = taglist_buttons,
  style = {
    font = font,
    bg_focus = "#44475a",
    fg_focus = "#f8f8f2",
    fg_empty = "#44475a",
  },
  widget_template = {
    {
      {
        {
          id     = 'index_role',
          widget = wibox.widget.textbox,
        },
        {
          id     = 'text_role',
          widget = wibox.widget.textbox,
        },
        layout = wibox.layout.fixed.horizontal,
      },
      left   = 15,
      right  = 15,
      widget = wibox.container.margin
    },
    id     = 'background_role',
    widget = wibox.container.background,
  },
})

local beautiful = require("beautiful")
beautiful.bg_systray = "#282a36"
local tray = wibox.widget({
  widget = wibox.widget.systray
})
tray:set_base_size(20)


local status_widgets = wibox.widget({
  layout = wibox.layout.fixed.horizontal,
  spacing = 10,
  font = font,
  {
    widget = wibox.container.place,
    tray,
  },
  {
    font = font,
    widget = wibox.widget.textclock
  },
  require("widgets.battery")("BAT0"),
  require("widgets.battery")("BAT1"),
  -- require("widgets.icon_text")(),
  -- test_widget
})

awful.wibar({
  bg = colors.background,
  fg = colors.foreground,
  font = font,
  height = 50,
  widget = wibox.widget({
    {
      layout = wibox.layout.align.horizontal,
      taglist,
      nil,
      status_widgets
    },
    widget = wibox.container.margin,
    top = 0,
    bottom = 0,
  })
})
