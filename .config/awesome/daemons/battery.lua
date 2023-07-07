local awful  = require("awful")
local gears = require("gears")
local debug = require("local_debug")

local timeout = 10

local batteries = { "BAT0", "BAT1" }

local function update()
  -- debug.print("here")
  local r = { }
  for _, battery in ipairs(batteries) do
    local capacity, charging
    local capacity_io = io.open("/sys/class/power_supply/"..battery.."/capacity")
    local status_io = io.open("/sys/class/power_supply/"..battery.."/status")
    capacity = tonumber(capacity_io:read("*all"))
    charging = string.find(status_io:read("*all"), "Charging") and true or false
    r[_] = {
      battery = battery,
      capacity = capacity,
      charging = charging
    }
  end
  awesome.emit_signal("battery::update", r)
end

local M = {}

local timer = gears.timer({
  timeout = timeout,
  -- call_now = true,
  callback = update
})

local charger_script = [[
    sh -c '
    acpi_listen | grep --line-buffered battery
    '
]]

M.start = function()
  timer:start()

  awful.spawn.easy_async_with_shell("ps x | grep \"acpi_listen\" | grep -v grep | awk '{print $1}' | xargs kill",
    function()
      awful.spawn.with_line_callback(charger_script, {
        stdout = function()
          awful.spawn.easy_async_with_shell("sleep 1", update)
        end
      })
    end)
end

M.request_update = update

return M
