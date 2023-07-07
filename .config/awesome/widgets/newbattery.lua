local wibox = require("wibox")

local debug = require("local_debug")

local M = { }
local mt = { }

local icons = {
  [100] = "󰁹",
  [90]  = "󰂂",
  [70]  = "󰂀",
  [60]  = "󰁿",
  [50]  = "󰁾",
  [40]  = "󰁽",
  [30]  = "󰁼",
  [20]  = "󰁻",
  [10]  = "󰁺",
  [0]   = "󰂃",
  charging = "󰂄"
}
local icon_keys = {}
for k, v in pairs(icons) do
  if type(k) == "number" then
    icon_keys[#icon_keys + 1] = k
  end
end
table.sort(icon_keys, function(a, b) return a > b end)


local function pick_icon(capacity)
  for _, key in ipairs(icon_keys) do
    if capacity >= key then
      return icons[key]
    end
  end
end


mt.__call = function()
  local pre_widget = wibox.widget({ widget = require("widgets.icon_text")})
  local widget = wibox.widget.base.make_widget(
    pre_widget
  )
  local _battery
  widget.set_battery = function(self, battery)
    _battery = battery
    require("daemons.battery").request_update()
  end
  awesome.connect_signal("battery::update", function(b)
    for _, data in ipairs(b) do
      if data.battery == _battery then
        pre_widget.icon = data.charging and icons.charging or pick_icon(data.capacity)
        pre_widget.text = math.min(data.capacity, 100) .. "%"
        break
      end
    end
  end)
  return widget
end

return setmetatable(M, mt)
