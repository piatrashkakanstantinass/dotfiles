local M = { }

local naughty = require("naughty")

M.print = function(s)
  naughty.notify({
    text = s,

  })
end

return M
