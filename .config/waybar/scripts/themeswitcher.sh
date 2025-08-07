#! /bin/bash

status=$(gsettings get org.gnome.desktop.interface color-scheme | tr -d "'")

if [ "$status" = "prefer-dark" ]; then
    gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
    matugen image ~/.config/rofi/current_wallpaper -m light
else
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    matugen image ~/.config/rofi/current_wallpaper -m dark
fi
