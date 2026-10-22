# Installation

## Automatic (WIP)

While there is an installation script that will set everything up, It is currently a work in progress and may not work for everyone. If you want to give it a try, follow the instructions here. Otherwise, you can follow the manual installation instructions in the next section.

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

## Manual (Recommended)

### 1. Clone the git repo

```sh
git clone https://github.com/bmalia/dotfiles.git
```

### 2. Install required packages
>[!NOTE]
> You'll need an AUR helper for this step. This guide uses `yay`, but you can use whatever you like; just replace the syntax accordingly.

```sh
source ./install/packages.conf && yay -S --needed "${base_packages[@]}" "${hematite_packages[@]}"
```

### 3. Install the dotfiles
```sh
cd dotfiles
make
```
This will symlink all the config files to their appropriate locations. After updates to the dotfiles, its good practice to run `make` again to make sure any structure changes or new config files are properly linked.

### 4. Reboot your system
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