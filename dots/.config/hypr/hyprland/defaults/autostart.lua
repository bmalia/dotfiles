---- AUTOSTART ----
-- Autostart applications and programs you want to run on startup here. Add your own to this same file in /custom, to avoid them breaking.

hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start hyprland-session.target") -- Notifies systemd services that a graphical session has been started, required for XDP v1.22+ to start for some reason
    hl.exec_cmd("awww-daemon") -- Wallpaper daemon
    hl.exec_cmd("nm-applet") -- NetworkManager applet
    hl.exec_cmd("systemctl --user start hyprpolkitagent") -- Authentication agent
    hl.exec_cmd("quickshell -c hematite") -- Graphical shell
    hl.exec_cmd("hypridle") -- Idle daemon
    hl.exec_cmd("swayosd-server") -- OSD for brightness, volume, etc.
    hl.exec_cmd("vicinae server") -- Launcher
    hl.exec_cmd("hyprpm reload") -- Load plugins
end)

hl.on("hyprland.shutdown", function ()
    os.execute("systemctl --user stop hyprland-session.target && sleep 0.1") -- Notifies systemd services that the graphical session has exited, required for XDP v1.22+
end)
