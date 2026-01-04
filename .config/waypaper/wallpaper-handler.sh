#!/bin/bash
# A script to handle color generation and hooks for waypaper
wallpaper="$1"
mode=$(gsettings get org.gnome.desktop.interface color-scheme)

if [ "$mode" = "'prefer-dark'" ]; then
    matugen image $wallpaper -t scheme-vibrant -m dark
else
    matugen image $wallpaper -t scheme-vibrant -m light
fi

ln -sf "$wallpaper" "$HOME/current_wallpaper"