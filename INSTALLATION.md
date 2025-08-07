# Installation

### Ensure you have the following packages installed:
```sh
yay -S --needed git hyprland kitty matugen swww waybar rofi-wayland nautilus swaync hyprlock hypridle ttf-jetbrains-mono-nerd cliphist adw-gtk-theme network-manager-applet waypaper swayosd nwg-look xdg-desktop-portal-hyprland xdg-desktop-portal-gtk hyprpolkitagent
```
*Feel free to use a different AUR helper* \
*If you're on a distro other than Arch, install all of the equivalent packages as needed*

### Clone the repo:
```sh
cd ~
git clone https://github.com/bmalia/dotfiles.git
```
### Switch to the branch for your version:
#### Desktop (GPU & weather waybar modules, different lockscreen, relaxed idle setup):
```sh
git checkout main
```
#### Laptop ( Battery waybar module, different lockscreen with fingerprint unlock, robust idle setup):
```sh
git checkout laptop
```
### Import the configs:
#### Using GNU-Stow
Stow is a symlink manager that allows you keep dotfiles and packages in one folder while symlinking them out to where they need to be. This will symlink out all of the files and configs from a folder in your home directory. \
**This method assumes the repo has been cloned to a folder in your home directory (e.g. `~/dotfiles`). If it is not, bad things can happen.**
```sh
sudo pacman -S --needed stow
cd ~/dotfiles # Or whatever the folder is named
rm -r ~/.config/hypr ~/.config/kitty ~/.config/matugen ~/.config/rofi ~/.config/waybar ~/.config/waypaper ~/.config/wlogout # Stow will fail if the directories it tries to link to are occupied. THIS WILL DELETE ALL DATA IN THESE FOLDERS, so make a backup if needed
stow .
```
Reboot if needed (you probably need to).
#### Manually
```sh
rm -r ~/.config/hypr ~/.config/kitty ~/.config/matugen ~/.config/rofi ~/.config/waybar ~/.config/waypaper ~/.config/wlogout # Same warning as above, make backups if needed.
cd ~/.dotfiles
cp -r . ~/
```
Reboot if needed (you probably need to).

# Post-installation stuff
### Generating colors
You'll probably get several configuration errors from various programs upon logging in again. This is normal, as colors for your wallpaper haven't been generated yet. To generate them:
1. Open up Waypaper
2. Waypaper checks in `~/Pictures/wallpapers` by default, but you can change the folder it opens in its settings.
3. Select an image. If nothing happens, ensure swww is selected on the bottom bar of the app, then try again.
4. Reboot. all of your config errors should be fixed now.

### Setting up GTK theming
*This wasn't included in the config because `adw-gtk3` complicates things with how it sets itself up.*
#### GTK3
1. Open or create `~/.config/gtk-3.0/gtk.css`.
2. Add the following line to the top of the file:
    ```css
    @import url('colors.css');
    ```
3. Save the file and open nwg-look (displays as 'GTK Settings' in Rofi).
4. In the 'Widgets' tab, select `adw-gtk3` from the list on the left and click 'Apply.'
5. Close the app and reboot, then open up a GTK3 app (like Waypaper). It should now have colors matching the rest of your UI.

#### GTK4
1. Open `~/.config/gtk-4.0`. The inside of the folder should look something like this:
    ```txt
    .
    ├── assets
    ├── colors.css
    ├── gtk.css
    ├── gtk-dark.css
    └── settings.ini
    ```
    With `assets`, `gtk.css`, and `gtk-dark.css` being symlinks to somewhere else.
2. Open `gtk.css` with `sudo` and delete the large block of `@define-color` statements at the top. The top line of the file should now be something like:
    ```css
    :root { --standalone-color-oklab: min(l, 0.5) a b; --accent-color: oklab(
    ```
3. Above that, add the following line:
    ```css
    @import url('colors.css');
4. Save the file and do the same thing with `gtk-dark.css`.
5. Reboot and open a GTK4 app (e.g. nautilus). It should now have colors matching the rest of your UI.

### Script permission changing
If the waybar modules for GPU or theme changing aren't working, or some of the lockscreen displays aren't showing up, do this:
```sh
cd ~/.config
chmod +x hypr/scripts/*
chmod +x waybar/scripts/*
``` 
### General housekeeping (WIP)
Because this config was built for my system, there will inevitably be some hardware components in your machine that don't present themselves the same way mine do. Here, we'll go through and make sure everything displays correct information.

#### Waybar
##### Temperatures (both configs)
The temperature display on the bottom bar might not be reading off of the correct sensors or thermal zones. To fix this:
1. Open up `~/.config/waybar/config.jsonc` and find the section towards the bottom that looks like this:
    ```jsonc
    "temperature#cpu": {
        "critical-threshold": 80,
        "interval": 2,
        "hwmon-path": "/sys/devices/platform/PNP0C14:00/wmi_bus/wmi_bus-PNP0C14:00/DEADBEEF-2001-0000-00A0-C90629100000/hwmon/hwmon5/temp3_input", // Change this if needed
        "format": "{icon} {temperatureC}°",
        "format-critical": "  {temperatureC}°",
        "format-icons": ["", "", "", ""],
        "on-click": "corectrl"
    },
    ```
2. Change the line marked 'change this if needed' to the path matching your device. *(Instructions TBA)*
3. *(Desktop config only)*  Do the same thing with the `temperature#gpu` object below that.

##### Battery (Laptop only)
If the battery indicator on the bottom bar doesn't show, it might be looking at a battery that doesn't exist. To fix it:
1. Open up `~/.config/waybar/config.jsonc` and find the section for the battery module. It should look like this:
    ```jsonc
    "battery": {
        "bat": "BAT1",
        "interval": "10",
        "format-icons": ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
        "format-discharging": "{icon} {capacity}%",
        "format-charging": "󰂄 {capacity}%",
        "states": {
        "warning": 30,
        "critical": 10
        }
    },
    ```
2. In a terminal, run:
    ```sh
    ls /sys/class/power_supply/
    ```
    And look at the result. There should be a folder labeled `BAT*` (with * being a number).
3. Go back to the config file and replace `BAT1` in the 2nd line with what the battery folder was named.

#### Lockscreen (Hyprlock)

