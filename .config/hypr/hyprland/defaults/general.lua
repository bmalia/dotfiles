local colors = require("hyprland.colors")
-- General settings for hyprland. This file is overridden by several files in /custom.

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- Gestures
hl.gesture({
    fingers = 3,
    direction = "pinch",
    action = "float"
})
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})
hl.gesture({
    fingers = 3,
    direction = "vertical",
    action = "special",
    workspace_name = "scratchpad"
})
hl.gesture({
    fingers = 4,
    direction = "vertical",
    action = "fullscreen"
})

-- General --
hl.config({
    general = {
        gaps_in = 10,
        gaps_out = 15,
        gaps_workspaces = 50,

        border_size = 1,
        col = {
            active_border = "rgba(0DB7D455)",
            inactive_border = "rgba(31313600)"
        },
        resize_on_border = true,
        layout = "dwindle",

        snap = {
            enabled = true,
            window_gap = 4,
            monitor_gap = 5,
            respect_gaps = true
        }
    },

    dwindle = {
        preserve_split = true
    },

    decoration = {
        rounding_power = 4,
        rounding = 18,

        blur = {
            enabled = true,
            xray = true,
            special = true,
            noise = 0.1,
            size = 10,
            passes = 3,
            brightness = 1,
            vibrancy = 0.5,
            vibrancy_darkness = 0.5
        },

        shadow = {
            enabled = true,
            range = 20,
            offset = {0, 2},
            render_power = 10,
            color = "rgba(00000020)"
        },

        dim_inactive = true,
        dim_strength = 0.05,
        dim_special = 0.2
    },

    animations = {
        enabled = true,
    }
})

-- Animations --
-- Material 3 Expressive spring equivalents (Hyprland's spring system doesn't match the one used for M3)
hl.curve("expressiveFastSpatial", {
    type = "bezier",
    points = {{0.42, 1.67}, {0.21, 0.90}}
})

hl.curve("expressiveDefaultSpatial", {
    type = "bezier",
    points = {{0.38, 1.21}, {0.22, 1.00}}
})

hl.curve("expressiveSlowSpatial", {
    type = "bezier",
    points = {{0.39, 1.29}, {0.35, 0.98}}
})

hl.curve("expressiveFastEffects", {
    type = "bezier",
    points = {{0.31, 0.94}, {0.34, 1.00}}
})

hl.curve("expressiveDefaultEffects", {
    type = "bezier",
    points = {{0.34, 0.80}, {0.34, 1.00}}
})

hl.curve("expressiveSlowEffects", {
    type = "bezier",
    points = {{0.34, 0.88}, {0.34, 1.00}}
})

hl.curve("standardFastSpatial", {
    type = "bezier",
    points = {{0.27, 1.06}, {0.18, 1.00}}
})

hl.curve("standardDefaultSpatial", {
    type = "bezier",
    points = {{0.27, 1.06}, {0.18, 1.00}}
})

hl.curve("standardSlowSpatial", {
    type = "bezier",
    points = {{0.27, 1.06}, {0.18, 1.00}}
})

hl.curve("standardFastEffects", {
    type = "bezier",
    points = {{0.31, 0.94}, {0.34, 1.00}}
})

hl.curve("standardDefaultEffects", {
    type = "bezier",
    points = {{0.34, 0.80}, {0.34, 1.00}}
})

hl.curve("standardSlowEffects", {
    type = "bezier",
    points = {{0.34, 0.88}, {0.34, 1.00}}
})

hl.animation({leaf = "border", enabled = true, speed = 2, bezier = "standardDefaultEffects"})
hl.animation({leaf = "windows", enabled = true, speed = 5, bezier = "expressiveDefaultSpatial"})
hl.animation({leaf = "windowsIn", enabled = true, speed = 5, bezier = "expressiveDefaultSpatial", style = "popin 50%"})
hl.animation({leaf = "workspaces", enabled = true, speed = 5, bezier = "expressiveDefaultSpatial"})
hl.animation({leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "expressiveDefaultSpatial", style = "slidevert"})
hl.animation({leaf = "fade", enabled = true, speed = 2, bezier = "expressiveDefaultEffects"})
hl.animation({leaf = "layers", enabled = true, speed = 3.5, bezier = "standardFastSpatial", style = "slide"})
hl.animation({leaf = "fadeLayers", enabled = true, speed = 1.5, bezier = "standardFastEffects"})

hl.config({
    -- Input --
    input = {
        kb_layout = "us",

        touchpad = {
            natural_scroll = true,
            clickfinger_behavior = true,
            scroll_factor = 0.8
        }
    },
    -- Misc --
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        focus_on_activate = true,
        session_lock_xray = true
    },

    binds = {
        hide_special_on_workspace_change = true
    },

    xwayland = {
        force_zero_scaling = true,
        use_nearest_neighbor = true
    }
})

hl.config({
    plugin = {
        hyprbars = {
            enabled = false, -- WIP
            bar_color = colors.background,
            col = {
                text = colors.on_surface
            },
            bar_text_font = "Google Sans",
            bar_text_size = 14,
            bar_height = 35,
            bar_padding = 12,
            bar_button_padding = 8,
            bar_precedence_over_border = true,
            bar_buttons_alignment = "left",
            icon_on_hover = true,
            inactive_button_color = colors.surface_container_high,
        }
    }
})

hl.plugin.hyprbars.add_button({
    bg_color = colors.error,
    fg_color = colors.on_error,
    size = 16,
    icon = "󰅖",
    action = "hyprctl dispatch hl.dsp.window.close\\(\\)"
})

hl.plugin.hyprbars.add_button({
    bg_color = colors.tertiary,
    fg_color = colors.on_tertiary,
    size = 16,
    icon = "󰊓",
    action = "hyprctl dispatch hl.dsp.window.fullscreen\\({action = \\\"toggle\\\"}\\)"
})

hl.plugin.hyprbars.add_button({
    bg_color = colors.primary,
    fg_color = colors.on_primary,
    size = 16,
    icon = "",
    action = "hyprctl dispatch hl.dsp.window.float\\({action = \\\"toggle\\\"}\\)"
})

