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
While GTK 4 matugen configuration is included in the repo, `adw-gtk` tends to overwrite it after rebooting. I haven't found a good method to stop this from happening, so it'll have to be fixed manually.

#### 1. Delete the color statements
Open `~/.config/gtk-4.0`. The folder structure should look something like this:
```
 .
├──  assets -> /usr/share/themes/adw-gtk3-dark/gtk-4.0/assets
├──  colors.css
├──  gtk-dark.css -> /usr/share/themes/adw-gtk3-dark/gtk-4.0/gtk-dark.css
├──  gtk.css -> /usr/share/themes/adw-gtk3-dark/gtk-4.0/gtk.css
└── 󱁻 settings.ini
```
With most of the files being symlinks to somewhere in `/usr/share/themes`. \
Now, open `gtk.css` with root (e.g. `sudo nano gtk.css`) and delete the large block of `@define-color` statements at the top. Your file should now look something like this:
```css
:root {
  --standalone-color-oklab: max(l, 0.85) a b;
  --accent-color: oklab(
    from var(--accent-bg-color) var(--standalone-color-oklab)
  );
  --destructive-color: oklab(
    from var(--destructive-bg-color) var(--standalone-color-oklab)
  );
  --success-color: oklab(
    from var(--success-bg-color) var(--standalone-color-oklab)
  );
  --warning-color: oklab(
    from var(--warning-bg-color) var(--standalone-color-oklab)
  );
  --error-color: oklab(
    from var(--error-bg-color) var(--standalone-color-oklab)
  );
  --active-toggle-bg-color: rgb(255 255 255 / 20%);
  --active-toggle-fg-color: #ffffff;
  --overview-bg-color: #28282c;
  --overview-fg-color: #ffffff;
}
@import "libadwaita.css";
@import "libadwaita-tweaks.css";
```

#### 2. Import matugen's colors
Now, add the following line to the very top of the file:
```css
@import "colors.css";
```
> **NOTE**: If you didn't see a `colors.css` file in the folder, follow the steps at [Generating colors for the first time](#generating-colors-for-the-first-time) to ensure Matugen is working properly.

Follow the same steps for `gtk-dark.css`. \
Log out and back in, or just restart your computer, and GTK 4 apps should work properly now.

### QT5 & 6
Open up `qt6ct` (Displays as `Qt6 settings`), select 'breeze' for the style and 'matugen' for the colors, then click 'OK'.