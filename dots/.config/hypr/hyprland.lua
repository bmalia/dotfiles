-- This is a root config file that sources everything else. DO NOT add config options here, they will break every time you update. Add your own options in hyprland/custom instead.
-- As a rule, don't edit any file in defaults to avoid conflicts. Add your own changes in the custom folder, which overrides the defaults.

-- Default configs
require("hyprland.defaults.envvars") -- Environment variables
require("hyprland.defaults.autostart") -- Autostart
require("hyprland.defaults.general") -- General settings
require("hyprland.defaults.keybinds") -- Keybinds
require("hyprland.defaults.rules") -- Window rules
require("hyprland.defaults.permissions") -- Permissions

-- Custom configs
require("hyprland.custom.general") -- General settings
require("hyprland.custom.autostart") -- Autostart
require("hyprland.custom.keybinds") -- Keybinds
require("hyprland.custom.rules") -- Window rules