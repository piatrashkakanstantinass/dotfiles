local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local default_margin = 5
local default_width = 500

local M = { }
local mt = {
  __call = function()
    local widget = wibox.widget({
      layout = wibox.layout.align.horizontal,
      forced_width = beautiful.title_width or default_width,
      expand = "outside",
      [2] = {
        layout = wibox.layout.fixed.horizontal,
        {
          widget = wibox.container.margin,
          margins = beautiful.title_icon_margin or default_margin,
          {
            id = "icon",
            widget = awful.widget.clienticon,
            client = {},
          },
        },
        {
          id = "text",
          widget = wibox.widget.textbox,
          ellipsize = "middle",
        }
      }
    })
    local function update_info(c)
      if c == client.focus then
        widget:get_children_by_id("icon")[1].client = c or {}
        widget:get_children_by_id("text")[1].text = c.name or ""
      end
    end
    client.connect_signal("focus", update_info)
    client.connect_signal("property::name", update_info)
    client.connect_signal("unfocus", function(c)
      widget:get_children_by_id("icon")[1].client = { }
      widget:get_children_by_id("text")[1].text = ""
    end)
    return wibox.widget.base.make_widget(widget)
  end
}

setmetatable(M, mt)

return M
