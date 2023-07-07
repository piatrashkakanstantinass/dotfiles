local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local M = {}
local mt = {}

local buttons = gears.table.join(
  awful.button({}, 1, function(t) t:view_only() end),
  awful.button({}, 4, function(t) awful.tag.viewnext() end),
  awful.button({}, 5, function(t) awful.tag.viewprev() end)
)

local default_args = {
  filter = awful.widget.taglist.filter.all,
  buttons = buttons,
  widget_template = {
    widget = wibox.container.background,
    id = "background_role",
    forced_width = beautiful.wibar_height,
    {
      widget = wibox.widget.textbox,
      id = "text_role",
      align = "center",
    }
  }
}

mt.__call = function(self, args)
  return awful.widget.taglist(
    gears.table.crush(gears.table.clone(default_args, false), args or { })
  )
end

setmetatable(M, mt)
return M
