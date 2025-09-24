#! /bin/bash
clear
echo "Hello!"
echo "This script will automatically install all of the packages needed for this setup and setup their config files."
echo "Note that this will not do any system-level configuration or setup (e.g. graphics drivers, users, etc.). You should handle these yourself."
sleep 1
echo ":: Step 1: Information Gathering"
echo ":: Checking for yay installation..."

if ! command -v yay &> /dev/null
then
    install_yay=true
    echo "   - Yay is not installed or is not useable in some form."
else
    install_yay=false
    echo "   - Yay is installed"
fi

echo "?: Which config version would you like to install?"
echo "   - 1. Desktop (GPU & weather waybar modules, relaxed idle management)"
echo "   - 2. Laptop (Battery waybar module, stricter idle management, fingerprint support, touchpad configuration)"
read -r -p "[1 or 2]=> " config_choice
if [ "$config_choice" -eq 1 ]; then
    config_version="desktop"
    echo ":: The desktop configuration will be installed."
elif [ "$config_choice" -eq 2 ]; then
    config_version="laptop"
    echo ":: The laptop configuration will be installed."
else
    echo ":: Invalid choice. Proceeding with desktop version"
    config_version="desktop"
fi

echo "?: Would you like to use GNU stow to manage the config files?"
read -r -p "[y/N]=> " use_stow
if [[ "$use_stow" =~ ^[Yy]$ ]]; then
    echo ":: GNU stow will be used to manage config files."
    use_stow=true
else
    echo ":: GNU stow will not be used."
    use_stow=false
fi

echo ":: Installation Summary:"
if [ "$install_yay" = true ]; then
    echo "   - Yay will be installed."
else
    echo "   - Yay will not be installed."
fi

echo "   - Config version: $config_version"

if [ "$use_stow" = true ]; then
    echo "   - GNU Stow will be used."
else
    echo "   - GNU Stow will not be used."
fi

echo ":: Make sure everything above is correct. You will not be able to change these during installation."
echo "?: Would you like to proceed with the installation?"
read -r -p "[y/N]=> " proceed
if [[ "$proceed" =~ ^[Yy]$ ]]; then
    echo ":: Beginning installation..."
else
    echo ":: Exiting..."
    exit 1
fi

echo ":: Step 2: Installing packages"
if [ "$install_yay" = true ]; then
    echo ":: Installing yay..."
    sudo pacman -S --noconfirm git base-devel
    git clone "https://aur.archlinux.org/yay.git"
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
    echo ":: Yay installed successfully."
fi

echo -n ":: Compiling package list... "
package_list=(
    "git"
    "hyprland"
    "kitty"
    "matugen-bin"
    "swww"
    "waybar"
    "rofi-wayland"
    "nautilus"
    "swaync"
    "hyprlock"
    "hypridle"
    "ttf-jetbrains-mono-nerd"
    "papirus-icon-theme"
    "cliphist"
    "adw-gtk-theme"
    "network-manager-applet"
    "waypaper"
    "swayosd"
    "nwg-look"
    "xdg-desktop-portal-hyprland"
    "xdg-desktop-portal-gtk"
    "hyprpolkitagent"
    "wlogout"
    "grimblast"
    "hyprpicker"
)
if [ $use_stow = true ]; then
    package_list+=("stow")
fi

if [ $config_version = "laptop" ]; then
    package_list+=(
        "brightnessctl"
        "fprintd"
    )
fi

if [ $config_version = "desktop" ]; then
    package_list+=(
        "wttrbar"
    )
fi

echo "Done"

echo ":: Installing packages with yay..."
yay -S --needed "${package_list[@]}"
echo ":: Package installation complete."
sleep 1

echo ":: Step 3: Cloning git repo"
cd ~
git clone https://github.com/bmalia/dotfiles.git
cd dotfiles
if [ $config_version = "laptop" ]; then
    git checkout laptop
fi
echo ":: Repo cloned successfully."

echo ":: Step 4: Configuring dotfiles"
echo "!: WARNING: This will overwrite any existing config files for hyprland, hyprlock, hypridle, kitty, matugen, rofi, waybar, and wlogout."
echo ":: You may want to create backups of them before proceeding."
echo "?: Would you like to proceed?"
read -r -p "[y/N]=> " proceed
if [[ "$proceed" =~ ^[Yy]$ ]]; then
    echo ":: Proceeding with configuration..."
else
    echo ":: Exiting..."
    exit 1
fi

echo ":: Deleting current config files..."
rm -r ~/.config/hypr ~/.config/kitty ~/.config/matugen ~/.config/rofi ~/.config/waybar ~/.config/waypaper ~/.config/wlogout

if [ $use_stow = true ]; then
    echo ":: Stowing repo to .config..."
    # stow .
else
    echo ":: Copying files to .config..."
    cp -r .config/* ~/.config/
fi
echo ":: Config files copied successfully."

echo ":: Step 5: Finalizing setup"
echo ":: Generating colors with placeholder image..."
# matugen image ~/dotfiles/scripts/placeholder-wallpaper.png -m dark
sleep 2
clear
echo ":: Installation complete!"
echo ":: See https://github.com/bmalia/dotfiles/blob/main/INSTALLATION.md#post-installation-stuff for some things you'll need to do after installation."
echo ":: General use overview:"
echo "   - Keybinds:"
echo "       - Open launcher: Super + Space"
echo "       - Open terminal: Super + T"
echo "       - Close active window: Super + Q"
echo "       - Open file manager: Super + E"
echo "   - A more comprehensive list of keybinds can be found in the README on the GitHub repository (https://github.com/bmalia/dotfiles)."
echo "   - Waybar:"
echo "       - Dark/light mode toggle can be found by hovering over the launcher button."
echo "       - Waybar can occasionally crash when launching a media player or beginning to play something. To restore it, run 'waybar & disown' in a terminal."
echo "   - Wallpapers:"
echo "       - Waypaper has been set up to re-generate material colors when switching wallpapers, so just use it to avoid any headaches."
sleep .5
echo ":: Enjoy your new setup!"
echo ":: Press any key to reboot the system."
read -n 1 -s
reboot
