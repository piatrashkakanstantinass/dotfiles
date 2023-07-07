local awful  = require("awful")
local gears = require("gears")
local debug = require("local_debug")

local volume_old = -1
local muted_old = -1
local function update()
  awful.spawn.easy_async_with_shell("pactl get-sink-mute @DEFAULT_SINK@; wpctl get-volume @DEFAULT_SINK@", function(stdout)
        local volume = stdout:match('Volume:%s+([%d.]+)')
        local muted = string.find(stdout:match('Mute:%s+(%a+)'), "yes") or false
        local muted_int = muted and 1 or 0
        local volume_int = math.tointeger(math.floor(tonumber(volume) * 100))
        -- Only send signal if there was a change
        -- We need this since we use `pactl subscribe` to detect
        -- volume events. These are not only triggered when the
        -- user adjusts the volume through a keybind, but also
        -- through `pavucontrol` or even without user intervention,
        -- when a media file starts playing.
      if volume_int ~= volume_old or muted_int ~= muted_old then
        awesome.emit_signal("volume::update", {
          volume = volume_int,
          muted = muted_int == 1
        })
        volume_old = volume_int
        muted_old = muted_int
      end
    end)
end

local M = {}

local volume_script = [[
    bash -c "
    LANG=C pactl subscribe 2> /dev/null | grep --line-buffered \"Event 'change' on sink #\"
    "]]

M.start = function()
  awful.spawn.easy_async({ "pkill", "--full", "--uid", os.getenv("USER"), "^pactl subscribe" }, function()
    awful.spawn.with_line_callback(volume_script, {
      stdout = update
    })
  end)
end

M.request_update = update

return M
