#!/bin/bash
echo "Hello!"
echo "This script will attempt to install the necessary packages and appy all of the configs for these dotfiles."
echo "You may be prompted for your password."
sleep 1

echo "Checking for yay installation..."
sleep 0.5
if ! command -v yay &> /dev/null
then
    echo "Yay is not installed or unuseable in some way."
    echo "Yay will be installed."
    install_yay=true
else
    echo "Yay is installed and useable."
    install_yay=false
fi
sleep 1

echo "Select the version of the dotfiles you want to install:"
echo "- Quickshell-based:"
echo "  - Monet-laptop (1)"
echo "  - Monet-desktop (Coming soon)"
echo "- Waybar-based:"
echo "  - Pixel-laptop (2)"
echo "  - Pixel-desktop (3)"
read -p "Enter the number corresponding to your choice: " choice
case $choice in
    1)
        config="monet-laptop";;
    2)
        config="pixel-laptop";;
    3)
        config="pixel-desktop";;
    *)
        echo "Invalid choice. Exiting."
        exit 1;;
esac
echo "Config selected: $config"
sleep 1

echo "Would you like to use GNU-Stow to manage the dotfiles?"
read -p "[Y/n]: " use_stow
sleep 1

echo "Installation summary:"
echo "Selected configuration: $config"
if [[ $install_yay = true ]]; then
    echo " - Yay will be installed"
fi
if [[ $use_stow = y || $use_stow = Y ]]; then
    echo " - Stow will be used"
else
    echo " - Dotfiles will be installed manually"
fi

echo "Would you like to begin the installation?"
read -p "[y/N]: " confirm
if [[ $confirm != y && $confirm != Y ]]; then
    echo "Exiting..."
    exit 1
fi

sleep 1
if [[ $install_yay = true ]]; then
    echo "Phase 0: Installing yay"
    echo -n "  - Downloading files... "
    git clone https://aur.archlinux.org/yay.git > /dev/null
    echo "Done"
    echo -n"  - Installing package... "
    cd yay
    makepkg -si --noconfirm > /dev/null
    echo "Done"
    sleep 0.5
    echo "Yay installed successfully!"
fi

sleep 1
echo "Phase 1: Installing packages"
echo -n "  - Compiling package list for config $config... "
source packages.conf
echo "Done"
echo "  - Installing packages..."
case $config in
    monet-laptop)
        yay -Syu --needed "${base_packages[@]}" "${laptop_packages[@]}" "${monet_packages[@]}";;
    pixel-laptop)
        yay -Syu --needed "${base_packages[@]}" "${laptop_packages[@]}" "${legacy_packages[@]}";;
    pixel-desktop)
        yay -Syu --needed "${base_packages[@]}" "${legacy_packages[@]}";;
    *)
        echo -n "Error"
        echo "Invalid config value: $config"
        echo "Exiting..."
        exit 1;
esac
echo "Packages installed successfully!"
sleep 1

echo "Phase 2: Installing configs"
echo -n "  - Switching to repo version for $config... "
cd ~/dotfiles
git pull > /dev/null
case $config in
    monet-laptop)
        git checkout main > /dev/null;;
    pixel-laptop)
        git checkout old-laptop > /dev/null;;
    pixel-desktop)
        git checkout old-desktop > /dev/null;;
    *)
        echo -n "Error"
        echo "Invalid config value: $config"
        echo "Exiting..."
        exit 1;
esac
echo "Done"
sleep .5
echo "WARNING: The configs for hyprland/lock/idle, waybar, quickshell, matugen, rofi, kitty, waypaper, and wlogout are about to be removed."
echo "If you would like to keep these, exit the script and back them up before coming back."
echo "Would you like to proceed?"
read -p "[y/N]: " dest_confirm
if [[ $dest_confirm != y && $dest_confirm != Y ]]; then
    echo "Exiting..."
    exit 1
fi
sleep 0.5
echo -n "  - Removing current configs... "
rm -r ~/.config/hypr ~/.config/kitty ~/.config/matugen ~/.config/quickshell ~/.config/rofi ~/.config/waybar ~/.config/waypaper ~/.config/wlogout > /dev/null
echo "Done"
if [[ $use_stow = y || $use_stow = Y ]]; then
    echo -n "  - Stowing ~/dotfiles to ~/.config... "
    stow .
    echo "Done"
else
    echo -n "  - Copying ~/dotfiles/.config/ to ~/.config... "
    cp -r .config/* ~/.config/
    echo "Done"
fi
sleep 0.5
echo "Configs installed successfully!"

echo "Installation complete!"
echo "Look at https://github.com/bmalia/dotfiles/blob/main/README.md for keybinds and general help"
echo "Follow post-installation procedures in https://github.com/bmalia/dotfiles/blob/main/INSTALLATION.md to get everything working properly."
echo "Open an issue on the GitHub if you notice any problems or have suggestions"
echo "Enjoy your new desktop!"
sleep 5
echo "[Press any key to reboot your system now.]"
read -n 1 -s
reboot