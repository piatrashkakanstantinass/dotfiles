local wibox = require("wibox")

local pre_widget = wibox.widget({
  widget = require("widgets.icon_text"),
  icon = "󰥔",
})

local widget = wibox.widget.base.make_widget(pre_widget, nil, { enable_properties = true })

