local wibox = require("wibox")
local debug = require("local_debug")

local icons = {
  [0] = "󰕿 ",
  [30] = "󰖀 ",
  [50] = "󰕾 ",
  muted = "󰖁 "
}

local icon_keys = {}
for k, v in pairs(icons) do
  if type(k) == "number" then
    icon_keys[#icon_keys + 1] = k
  end
end
table.sort(icon_keys, function(a, b) return a > b end)

local function pick_icon(value)
  for _, key in ipairs(icon_keys) do
    if value >= key then
      return icons[key]
    end
  end
end

local pre_widget = wibox.widget({
  widget = require("widgets.icon_text"),
  icon = icons[50],
  spacing = 0
})

local widget = wibox.widget.base.make_widget(pre_widget)

awesome.connect_signal("volume::update", function(v)
  pre_widget.text = v.muted and "" or v.volume .. "%"
  pre_widget.icon = v.muted and icons.muted or pick_icon(v.volume)
end)

require("daemons.volume").request_update()


return widget
