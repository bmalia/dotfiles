---- AUTOSTART ----
-- Autostart applications and programs you want to run on startup here. Add your own to this same file in /custom, to avoid them breaking.

hl.on("hyprland.start", function()
    hl.exec_cmd("awww-daemon") -- Wallpaper daemon
    hl.exec_cmd("nm-applet") -- NetworkManager applet
    hl.exec_cmd("systemctl --user start hyprpolkitagent") -- Authentication agent
    hl.exec_cmd("quickshell -c yosemite") -- Graphical shell
    hl.exec_cmd("hypridle") -- Idle daemon
    hl.exec_cmd("swayosd-server") -- OSD for brightness, volume, etc.
    hl.exec_cmd("vicinae server") -- Launcher
    hl.exec_cmd("hyprpm reload") -- Load plugins
end)
