#!/bin/bash
# A script to handle color generation and hooks for waypaper
wallpaper="$1"
mode=$(gsettings get org.gnome.desktop.interface color-scheme)

if [ -f "$HOME/.config/hematite/colorgen/color_index" ]; then
    color_index=$(cat ~/.config/hematite/colorgen/color_index)
else
    echo "0" > ~/.config/hematite/colorgen/color_index
    color_index=0
fi

if [ -f "$HOME/.config/hematite/colorgen/scheme" ]; then
    scheme=$(cat ~/.config/hematite/colorgen/scheme)
  else
    scheme="scheme-tonal-spot"
    echo "scheme-tonal-spot" > ~/.config/hematite/colorgen/scheme
fi

if [ "$mode" = "'prefer-dark'" ]; then
    matugen image "$wallpaper" -t "$scheme" -m dark --source-color-index "$color_index"
else
    matugen image "$wallpaper" -t "$scheme" -m light --source-color-index "$color_index"
fi

# Store wallpaper path in a state file
echo "$wallpaper" > ~/.local/state/quickshell/hematite/wallpaper_path