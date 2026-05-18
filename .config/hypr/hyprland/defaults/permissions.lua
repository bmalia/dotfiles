hl.config({
    ecosystem = { enforce_permissions = true },
})

-- Screen capture --
-- Defalut is to ask, exceptions below
hl.permission({ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" }) -- Anything going through the portal is fine, it's the point of the portal to authorize first
hl.permission({ binary = "/usr/bin/grim", type = "screencopy", mode = "allow" }) -- Screenshotting is fine

-- Plugins --
-- You should really only be allowing hyprpm to load plugins. There's no reason for anything else to be doing so without malicious intent.
hl.permission({ binary = "/usr/bin/hyprpm", type = "plugin", mode = "allow" })

-- Keyboard --
-- Ideally, this prevents things like rubber duckies, but 

