local awful = require("awful")
require("awful.autofocus")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")

-- Daemons
require("daemons.battery").start()
require("daemons.volume").start()

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

require("keys")
require("tags")
-- require("bar")
local newbar = require("newbar")

awful.screen.connect_for_each_screen(function(s)
  newbar({ screen = s, position = "top" })
end)

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

gears.wallpaper.maximized(".local/share/wallpaper.jpg")
client.connect_signal("mouse::enter", function(c) awful.client.focus.byidx(0, c) end)
client.connect_signal("property::floating", function(c)
  if not c.fullscreen then
    if c.floating then
        c.ontop = true
    else
        c.ontop = false
    end
  end
end)

local clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ "Mod4" }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ "Mod4" }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

local unfocused_border = "#282a36"
local focused_border = "#50fa7b"
awful.rules.rules = {
  {
    rule = { },
    properties = {
      border_width = 2,
      border_color = unfocused_border,
      buttons = clientbuttons,
      raise = true,
      focus = awful.client.focus.filter,
      size_hints_honor = false,
      placement = awful.placement.centered
    }
  },
  {
    rule = {
      class = "qBittorrent"
    },
    properties = {
      tag = "9"
    },
  },
  {
    rule = {
      class = "firefox"
    },
    properties = {
      tag = "2",
      switchtotag = true
    },
  },
}

client.connect_signal("focus", function(c)
  c.border_color = focused_border
end)
client.connect_signal("unfocus", function(c)
  c.border_color = unfocused_border
end)

awful.spawn({"picom", "-b"}, false)
awful.spawn({"xset", "r", "rate", "250", "25"}, false)
awful.spawn.with_shell("setxkbmap -layout us,lt,ru -option ctrl:nocaps,grp:alt_shift_toggle")
awful.spawn.easy_async_with_shell("pkill xss-lock; xss-lock -l -- betterlockscreen -l")

awful.spawn.easy_async_with_shell("pkill qbittorrent; qbittorrent")
