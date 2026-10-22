#! /bin/bash

set -oe pipefail

function update_packages() {
    echo "Updating packages..."
    yay -Syu
    echo "Packages updated successfully."
}

function update_repo() {
    echo "Updating repository..."
    git pull origin main
    echo "Repository updated successfully."
}

function install_packages() {
    update_packages
    echo "Installing packages..."
    source packages.conf
    # Install pacman packages
    echo " - Installing pacman packages..."
    sudo pacman -S --needed "${pacman_packages[@]}"
    # Install AUR packages
    echo " - Installing AUR packages..."
    sudo yay -S --needed "${aur_packages[@]}"
    echo "Packages installed successfully."
}

function clear_current_configs() {
    echo "Clearing current configurations..."
    echo "WARNING: This will remove all current configuration files for the applications configured by these dotfiles. If you have any important configurations, please back them up before proceeding."
    echo "Would you like to continue? (y/n)"
    read -r response
    if [[ "$response" != "y" ]]; then
        echo "Aborting."
        exit 1
    fi
    # For each folder in the dots/.config directory, remove the corresponding folder in the ~/.config directory
    echo " - Removing zsh files..."
    rm ~/.zshrc ~/.zshenv
    echo " - Removing config files..."
    for folder in dots/.config/*; do
        if [ -d "$folder" ]; then
            echo "   - Removing $(basename "$folder") configuration"
            rm -rf "~/.config/$(basename "$folder")"
        fi
    done
    echo "Current configurations cleared successfully."
}

function install_gtk_theme() {
    echo "Installing adw-gtk3 theme..."
    # Download the theme
    echo " - Downloading release..."
    curl -s https://api.github.com/repos/lassekongo83/adw-gtk3/releases/latest | grep "browser_download_url.*\.tar\.xz" | cut -d '"' -f 4 | xargs -I {} curl -L -o /tmp/adw-gtk3.tar.xz {}
    echo " - Installing release to .themes..."
    tar -xf /tmp/adw-gtk3.tar.xz -C ~/.themes
    echo "Theme installed successfully."
}

function install_dotfiles() {
    update_repo
    echo "Stowing dotfiles..."
    stow --verbose --target=$HOME --restow dots
    echo "Dotfiles stowed successfully."
}

function compile_qs_modules() {
    echo "Compiling and installing Quickshell modules..."
    repo_directory=$(pwd)
    cd ~/.config/quickshell/hematite/
    cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
    cmake --build build
    echo "Compiled all modules successfully."
    echo "Installing modules (You may be prompted for your password)..."
    sudo ln -sf ~/.config/quickshell/hematite/plugins/build/qml/Hematite /usr/lib/qt6/qml/
    echo "Compiled and installed all modules successfully."
    cd "$repo_directory"
}

function generate_colors() {
    echo "Generating matugen colors..."
    mkdir -p ~/Pictures/wallpapers
    cp assets/default_wallpaper.png ~/Pictures/wallpapers/default_wallpaper.png
    matugen image assets/default_wallpaper.jpg -m dark --source-color-index 0
    echo "Matugen colors generated successfully."
}

function unstow_dotfiles() {
    echo "Unstowing dotfiles..."
    stow --verbose --target=$HOME --delete dots
    echo "Dotfiles unstowed successfully."
}

function clear_data() {
    echo "Clearing leftover shell data..."
    rm -rf ~/.local/state/quickshell/hematite
	rm -rf ~/.themes/adw-gtk3 ~/.themes/adw-gtk3-dark
	echo "Leftover shell data cleared successfully."
}

# Script entry point
if [[ "$1" == "install" ]]; then
    echo "Please note that this script requires yay to function properly. If you do not have yay installed, please install it first."
    echo "Installing Hematite dotfiles..."
    echo "Tasks to perform:"
    echo " - Install packages"
    echo " - Clear current configurations"
    echo " - Install GTK theme"
    echo " - Install dotfiles"
    echo " - Compile Quickshell modules"
    echo " - Generate colors"
    echo "Do you wish to proceed? (y/n):"
    read -r response
    if [[ "$response" != "y" ]]; then
        echo "Aborting."
        exit 1
    fi
    install_packages
    clear_current_configs
    install_gtk_theme
    install_dotfiles
    compile_qs_modules
    generate_colors
    echo "Hematite dotfiles installed successfully. Enjoy!"
elif [[ "$1" == "update" ]]; then
    echo "Updating current Hematite dotfiles installation..."
    echo "Tasks to perform:"
    echo " - Update packages"
    echo " - Update repository"
    echo " - Restow dotfiles"
    echo " - Compile Quickshell modules"
    echo "Do you wish to proceed? (y/n):"
    read -r response
    if [[ "$response" != "y" ]]; then
        echo "Aborting."
        exit 1
    fi
    update_packages
    install_dotfiles
    compile_qs_modules
    echo "Hematite dotfiles updated successfully."
elif [[ "$1" == "remove" ]]; then
    echo "Removing Hematite dotfiles installation..."
    echo "Tasks to perform:"
    echo " - Unstow dotfiles"
    echo " - Clear leftover shell data"
    echo "Do you wish to proceed? (y/n):"
    read -r response
    if [[ "$response" != "y" ]]; then
        echo "Aborting."
        exit 1
    fi
    unstow_dotfiles
    clear_data
    echo "Hematite dotfiles removed successfully. Unfortunately, there isn't a way to remove the installed packages safely, as they may be used by other applications. You can manually remove them if you wish. Packegs used by the shell are listed in install/packages.conf."
else
    echo "Invalid mode. Please specify 'install', 'update', or 'remove'."
    exit 1
fi
