local colors = require("hyprland.colors")
-- Window Rules --
local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name           = "suppress-maximize-events",
    match          = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name = "float-modals",
    match = {
        title = "^(Open File|Select a File|Save As|Open Folder|File Upload|(.*)(wants to save))(.*)$",
    },
    float = true,
    center = true,
})

hl.window_rule({
    name = "picture-in-picture",
    match = {
        title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$",
    },
    float = true,
    pin = true,
    keep_aspect_ratio = true,
    move = {"monitor_w * .75", "monitor_h * .25"},
})

hl.window_rule({
    name = "fix-jetbrains",
    match = {
        class = "match:class ^jetbrains-.*$",
        float = true,
        title = "match:title ^$|^\\s$|^win\\d+$"
    },
    no_initial_focus = true
})

hl.window_rule({
    name = "pin-screenshare",
    match = {
        title = ".*is sharing (a window|your screen).*",
    },
    pin = true,
    float = true,
    move = {"monitor_w * .5 - window_w * .5", "monitor_h * - window_h - 12"},
})

hl.window_rule({
    name = "dont-blur-special",
    no_blur = true,
    match = {
        workspace = "special:scratchpad"
    }
})
hl.layer_rule({
    name = "vicinae-blur",
    blur = true,
    ignore_alpha = false,
    match = {
        class = "^vicinae$",
    }
})

hl.layer_rule({
    name = "quickshell-blur",
    blur = true,
    ignore_alpha = false,
    match = {
        class = "^quickshell$",
    }
})

hl.workspace_rule({
    workspace = "special:scratchpad",
    gaps_out = 40,
    no_shadow = true,
})

-- Reverse smart gaps for hidpi screens
--[[
hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 70, gaps_in = 10 })
hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 70, gaps_in = 10 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, rounding = 20 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, border_color = colors.primary })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, rounding = 20 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, border_color = colors.primary})
--]]
