# Installation

*I'm currently in the process of moving to Quickshell, so some information here might not be totally accurate, and things might not be the same across the different branches.*

## Automatic (recommended)

I've made an installation script to automatically install all of the packages and setup the config files. It has been tested on a bare-bones install of Arch Linux, but I can't guarantee it works on your system. Make backups and use caution before running it.

### 1. Clone the git repo

```sh
cd ~
git clone https://github.com/bmalia/dotfiles.git
```

### 2. Run the installation script

```sh
cd dotfiles
./install.sh
```

## Manual

### 1. Clone the git repo

```sh
git clone https://github.com/bmalia/dotfiles
cd dotfiles
```

### 2. Select your version

There are are few different versions of the shell you can install:

- Quickshell:
  - Laptop (Battery module, touchpad gestures, strict idle management): `main`
- Waybar (Legacy):
  - Desktop (Windows-like status bar, relaxed idle management): `old-desktop`
  - Laptop (Hybrid status bar, touchpad gestures, strict idle management): `old-laptop`

Once you have selected your desired version, switch to its git branch:

```sh
git checkout <branch-name>
```

### 3. Install packages

```sh
cd dotfiles
source packages.conf && yay -Syu <package arrays>
```

**Replace `<package arrays>` with the following depending on your version:**

- Quickshell:
  - Laptop: `"${base_packages[@]}" "${laptop_packages[@]}" "${monet_packages[@]}`
- Waybar/legacy:
  - Laptop: `"${base_packages[@]}" "${laptop_packages[@]}" "${legacy_packages[@]}"`
  - Desktop: `"${base_packages[@]}" "${legacy_packages[@]}"`

\* _If you don't use yay, substitute it for your AUR helper/wrapper_ \
\* _If you're not on an Arch-based distro, install all of the equivalent packages through your package manager. You can find the packages used in the `packages.conf` file._

### 4. Install the config

Keep in mind this will overwrite any configs for the designated programs. Make backups if you need to.

#### Using Stow (recommended):

`Stow` expects the repo to be in a folder that is directly inside your home folder (e.g. `~/dotfiles`). If it is not (e.g. `~/Downloads/dotfiles`), bad things can happen.

```sh
yay -S --needed stow
rm -r ~/.config/hypr ~/.config/kitty ~/.config/matugen ~/.config/quickshell ~/.config/rofi ~/.config/waybar ~/.config/waypaper ~/.config/wlogout
cd dotfiles
stow .
```

#### Manually

```sh
rm -r ~/.config/hypr ~/.config/kitty ~/.config/matugen ~/.config/quickshell ~/.config/rofi ~/.config/waybar ~/.config/waypaper ~/.config/wlogout

cd ~/dotfiles
cp -r .config/* ~/.config/
```

### 5. Reboot your system

```sh
shutdown -r now
```
<br>
<br>

# Post-installation and housekeeping

## Generating colors for the first time
**You only have to do this if you installed manually. The installation script will generate placeholder colors for you after setting everything up.**

You may notice a a few errors from Hyprland and Quickshell upon logging back in. This is because the color files they source from don't exist yet. You can fix this pretty simply.

### 1. Get an image to use as a wallpaper
This should be pretty simple. I recommend [Unsplash](https://unsplash.com) if you're looking for photography. Save whatever image you find to `~/Pictures/wallpapers`.

### 2. Set the wallpaper
Open Waypaper and wait a second for it to cache your images. If nothing shows up, it's configured to look in `~/Pictures/wallpapers` by default, so try moving your image there if you can. Select the wallpaper you want to use and wait a second. The Hyprland error should go away (you'll probably have to restart Quickshell by running `quickshell -d`), and theming for your apps should work properly now.


## Applying themes for different platforms
Because the 2 main UI toolkits require you to set the theme manually, you have to do that before they start looking nice.

### GTK 3
Open `nwg-look` (Shows up as 'GTK Settings' in most app launchers) and select either `adw-gtk3` or `adw-gtk3-dark` on the left side, then click apply and OK.

### GTK 4
GTK 4 should work automatically assuming you have matugen set up.

### QT5 & 6
Open up `qt6ct` (Displays as `Qt6 settings`), select 'breeze' for the style and 'matugen' for the colors, then click 'OK'.