local gears = require("gears")
local wibox = require("wibox")

local colors = require("colors")

-- local settings = require("settings")

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

local function read_file(file)
  local f = io.open(file)
  if not f then error("failed reading resource: " .. file) end
  return f:read("*a")
end

local function get_state(path)
  local status = read_file(path .. "status")
  local charging = false
  if status:find("Charging") then charging = true end
  return {
    capacity = tonumber(read_file(path .. "capacity")),
    charging = charging
  }
end

return function(battery)
  if type(battery) ~= "string" then error("string expected") end
  local path = "/sys/class/power_supply/" .. battery .. "/"
  local _ = io.open(path .. "capacity")
  if not _ then error("cannot open battery: " .. battery) end
  _:close()

  local widget = wibox.widget({
    {
      {
        {
          id = "icon",
          widget = wibox.widget.textbox,
          -- font = settings.icon_font
        },
        widget = wibox.container.place,
        forced_width = 50,
      },
      widget = wibox.container.background,
      bg = colors.foreground,
      fg = colors.background
    },
    {
      {
        {
          widget = wibox.container.place,
          {
            id = "text",
            widget = wibox.widget.textbox,
          }
        },
        widget = wibox.container.margin,
        -- left = 18,
        -- right = 18,
        forced_width = math.floor(50 * 1.5)
      },
      widget = wibox.container.background,
      bg = colors.current_line,
      fg = colors.foreground
    },
    layout = wibox.layout.fixed.horizontal,
    -- spacing = settings.text_icon_spacing
  })

  gears.timer({
    timeout = 10,
    autostart = true,
    call_now = true,
    callback = function()
      local state = get_state(path)
      local icon = state.charging and icons.charging or pick_icon(state.capacity)
      widget:get_children_by_id("icon")[1].text = icon
      widget:get_children_by_id("text")[1].text = state.capacity .. "%"
    end
  })

  return widget
end
