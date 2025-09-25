# Installation

_I'm currently in the process of moving to Quickshell, so some information here might not be totally accurate, and things might not be the same across the different branches._

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

### 1. Install packages

**_Subject to rapid change w/ Quickshell update_**

```sh
yay -S --needed git hyprland gdm hyprlock swww nautilus kitty quickshell network-manager-applet zsh ttf-roboto adwaita-fonts ttf-jetbrains-mono-nerd upower matugen adw-gtk3 breeze swaync swayosd waypaper hypridle
```

\* _If you don't use yay, substitute it for your AUR helper/wrapper_ \
\* _If you're not on an Arch-based distro, install all of the equivalent packages through your package manager_

### 2. Clone the git repo

```sh
git clone https://github.com/bmalia/dotfiles
cd dotfiles
```

### 3. Select your version

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

### 4. Install the config

Keep in mind this will overwrite any configs for the designated programs. Make backups if you need to.

#### Using Stow (recommended):

`Stow` expects the repo to be in a folder that is directly inside your home folder (e.g. `~/dotfiles`). If it is not (e.g. `~/Downloads/dotfiles`), bad things can happen.

```sh
yay -S --needed stow
cd dotfiles
stow .
```

#### Manually

```sh
rm -r ~/.config/hypr ~/.config/kitty ~/.config/matugen ~/.config/quickshell ~/.config/rofi ~/.config/waybar ~/.config/waypaper ~/.config/wlogout

cd ~/dotfiles
cp -r .config/* ~/.config/
```
