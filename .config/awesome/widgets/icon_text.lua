local wibox = require("wibox")
local beautiful = require("beautiful")
local debug = require("local_debug")

local M = { }
local mt = { }

mt.__call = function()
  local proxy = wibox.widget({
    layout = wibox.layout.fixed.horizontal,
    spacing = 5,
    {
      id = "icon",
      font = beautiful.icon_font,
      widget = wibox.widget.textbox,
    },
    {
      id = "text",
      widget = wibox.widget.textbox
    }
  })
  local widget = wibox.widget.base.make_widget(proxy, nil, {enable_properties = true})
  widget.set_text = function(self, text)
    proxy:get_children_by_id("text")[1].text = text
  end
  widget.set_icon = function(self, icon)
    proxy:get_children_by_id("icon")[1].text = icon
  end
  widget.set_text_widget = function(self, text_widget)
    proxy.children[2] = wibox.widget(text_widget)
  end
  widget.set_spacing = function(self, spacing)
    proxy.spacing = spacing
  end
  return widget
end

return setmetatable(M, mt)
