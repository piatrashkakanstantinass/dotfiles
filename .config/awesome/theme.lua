local colors = require("colors")

local font = "JetBrainsMono Nerd Font 10"
local icon_font = "JetBrainsMono Nerd Font 15"

return {
  wibar_bg = colors.background,
  wibar_fg = colors.foreground,
  wibar_height = 40,

  taglist_bg_focus = colors.comment,
  taglist_fg_empty = colors.comment,
  taglist_font = font,

  separator_span_ratio = 0.5,

  font = font,
  icon_font = icon_font,

  bg_systray = colors.background,
  systray_icon_spacing = 5
}
