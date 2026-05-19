#! /bin/bash

set -oe pipefail

function gather_system_info() {
    echo -ne "\e[1mGathering system information...\x1b[0m "
    sleep 0.5
    # check os-release for arch
    if [[ -f /etc/os-release ]]; then
        # get the id and id_like fields
        . /etc/os-release
        if [[ $ID == "arch" || $ID_LIKE == *"arch"* ]] 
        then
            dist="arch"
        else
            echo -e "\e[31mError\e[0m"
            echo "└─This installer only supports Arch and Arch-like distros. Support for other distros is coming soon."
            exit 1
        fi
    else
        echo "Cannot determine distribution."
        exit 1
    fi
    # check for yay
    if command -v yay &> /dev/null
    then
        yay=true
        echo -e "\e[32mDone\e[0m"
    else
        yay=false
        echo -e "\e[32mDone\e[0m"
        echo -e "\e[2;37m└─Yay isn't installed, will be installed later.\e[0m"
    fi
}

function get_release() {
    echo -e "\e[1mWhich release channel do you want to install?\e[0m"
    echo "1) Stable"
    echo "2) Staging"
    read -rp "=> " release_channel
    if [[ $release_channel -gt 2 || $release_channel -lt 1 ]]; then
        echo "Invalid release channel."
        exit 1
    fi
}

function install_yay() {
    echo -e "\e[1mInstalling yay...\x1b[0m"
    sleep 0.5
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    cd ~
    rm -rf /tmp/yay
    echo -e "\e[32mDone\e[0m"
}

function install_packages() {
    echo -e "\e[1mInstalling packages...\x1b[0m"
    echo -e "For your computer's safety, the package installation will \e[1mNOT\e[0m be done unattended. Your input will be required to confirm installation and intervene if required."
    echo "This script will automatically exit if at any point a package fails to install."
    echo "Proceeding in 5 seconds."
    sleep 5
    source packages.conf
    yay -Syu --needed "${base_packages[@]}" "${yosemite_packages[@]}"
    if [[ $? -ne 0 ]]; then
        echo -e "\e[31mError\e[0m"
        echo "└─Package installation failed. Please check the output above for more details."
        exit 1
    fi
    echo -e "\e[32mDone\e[0m"
}

function install_configs() {
    echo -e "\e[1mInstalling configs...\x1b[0m"
    sleep 0.5
    cd "$(dirname "${BASH_SOURCE[0]}")"
    echo -en "Switching to release branch... "
    case "$release_channel" in
        1)
            git checkout main;;
        2)
            git checkout staging;;
    esac
    echo -e "\e[32mDone\e[0m"
    echo -e "\e[33;1mNote: This script is about to overwrite your existing configs with the ones provided by yosemite. Would you like to back up your existing configs before proceeding?\e[0m"
    read -rp "(y/n) => " backup
    if [[ $backup == "y" ]]; then
        echo -e "\e[1mBacking up configs...\x1b[0m"
        mkdir -p ~/config-bak
        mkdir -p ~/config-bak/.config
        mkdir -p ~/config-bak/.local
        echo -e "\e[2;37m├─Created backup directories in ~/config-bak\e[0m"
        echo -e "\e[2;37m├─Backing up .config...\e[0m"
        for dir in fastfetch gtk-3.0 gtk-4.0 hypr kitty Kvantum matugen qt6ct quickshell swaync swayosd waypaper wlogout; do
            [[ -d ~/.config/$dir ]] && mv ~/.config/$dir ~/config-bak/.config/
            echo -e "\e[2;37m│ ├─Backed up $dir\e[0m"
        done
        echo -e "\e[2;37m├─Backing up .themes...\e[0m"
        mv ~/.themes ~/config-bak/
        echo -e "\e[2;37m│ ├─Backed up .themes\e[0m"
        echo -e "\e[1mDone\e[0m"
    else
        rm -rf ~/.config/fastfetch ~/.config/gtk-3.0 ~/.config/gtk-4.0 ~/.config/hypr ~/.config/kitty ~/.config/Kvantum ~/.config/matugen ~/.config/qt6ct ~/.config/quickshell ~/.config/swaync ~/.config/swayosd ~/.config/waypaper ~/.config/wlogout
        rm -rf ~/.themes
        echo "Existing configs have been removed. Proceeding..."
    fi

    echo -e "\e[1mStowing in configs...\x1b[0m"]
    cd "$(dirname "${BASH_SOURCE[0]}")"
    stow .
    echo -e "\e[32mDone\e[0m"
}

function post_install() {
    echo -e "\e[1mPerforming post-install tasks...\x1b[0m"
    sleep 0.5
    echo -en "\e[2;37m├─Generating matugen colors...\e[0m "
    matugen image ./assets/default_wallpaper.jpg -m dark
    echo -e "\e[32mDone\e[0m"
    echo -en "\e[2;37m├─Setting wallpaper...\e[0m "
    swww img ./assets/default_wallpaper.jpg
    echo -e "\e[32mDone\e[0m"
    echo -en "\e[2;37m├─Generating template configs...\e[0m "
    cp ~/.config/hyper/user-template.conf ~/.config/hyper/user.conf
    
}

echo "Hello!"
echo "This script will install Yosemite-Shell onto your system."
echo "Please ensure you make backups of any important data or configurations before proceeding, this script may be destructive."
echo "---------------------------------"
gather_system_info
get_release
echo -e "\e[1mSummary:\e[0m"
echo -e "├─ Release channel: \e[32m$release_channel\e[0m"
echo -e "└─ Installing yay: \e[32m$yay\e[0m"
echo "---------------------------------"
read -rp "Are you ready to proceed? (y/n) " ready
if [[ $ready != "y" ]]; then
    echo "Aborting installation."
    exit 0
fi

if [[ $yay != true ]]; then
    install_yay
fi
sleep 0.5

install_packages
sleep 0.5
install_configs