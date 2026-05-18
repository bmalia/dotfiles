-- Custom General --
-- Put your own general settings here, like monitors, input devices, or animations. Note
-- that this will override the default settings if you set the same properties again.

local colors = require("hyprland.colors") -- You can use generated matugen colors with colors.NAME, if you wish.

-- Monitors
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})
