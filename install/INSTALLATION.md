# Installation

## Automatic (Recommended)

The installation script is designed to work on most Arch systems, but I can't guarantee anything. If you run into issues, proceed manually with the steps below.

### 1. Clone the git repo

```sh
cd ~
git clone https://github.com/bmalia/dotfiles.git
```

### 2. Run the installation script

```sh
cd dotfiles
./install.sh install
```

## Manual

### 1. Clone the git repo

```sh
git clone https://github.com/bmalia/dotfiles.git
```

### 2. Install required packages
>[!NOTE]
> You'll need an AUR helper for this step. This guide uses `yay`, but you can use whatever you like; just replace the syntax accordingly.

```sh
source ./install/packages.conf # Get the list of packages to install
pacman -Syu --needed "${pacman_packages[@]}"
yay -Syu --needed "${aur_packages[@]}"
```

### 3. Install the dotfiles
```sh
cd dotfiles
git pull # Make sure you have the latest version
stow --verbose --target=$HOME --restow dots
```
This will symlink all the config files to their appropriate locations. After updates to the dotfiles, its good practice to run `stow --verbose --target=$HOME --restow dots` again to make sure everything is up to date.

### 4. Compile Quickshell modules
As the configuration relies on custom QML modules, you'll need to compile them before you can use the shell. Run the following commands:
```sh
cd ~/dotfiles/dots/.config/quickshell/plugins
# Caelestia blobs lib
cd Blobs
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

### 5. Install adw-gtk3 theme
```sh
mkdir -p ~/.themes
cd .themes
curl -s https://api.github.com/repos/lassekongo83/adw-gtk3/releases/latest | grep "browser_download_url.*\.tar\.xz" | cut -d '"' -f 4 | xargs -I {} curl -L -o adw-gtk3.tar.xz {}
```
You should now have a file called `adw-gtk3.tar.xz` in your .themes directory. Extract it with the following command:
```sh
tar -xf adw-gtk3.tar.xz
```

### 6. Reboot your system
```sh
reboot # try 'systemctl reboot' if this doesn't work
```

# Post-installation and housekeeping

## Applying themes for different platforms
Because the 2 main UI toolkits require you to set the theme manually, you have to do that before they start looking nice.

### GTK 3
Open `nwg-look` (Shows up as 'GTK Settings' in most app launchers) and select either `adw-gtk3` or `adw-gtk3-dark` on the left side, then click apply and OK.

### GTK 4
GTK 4 should work automatically assuming you have matugen set up.

### QT5 & 6
Open up `qt6ct` (Displays as `Qt6 settings`), select 'breeze' for the style and 'matugen' for the colors, then click 'OK'.

# Uninstallation
Run the following: 
```sh
make remove
```
This will remove all the symlinks and delete the shell's state directory. It will NOT uninstall packages in case you have things that depend on them to avoid breaking your system. You can remove them manually in the same way you would remove any other package, following the syntax in the installation step.
