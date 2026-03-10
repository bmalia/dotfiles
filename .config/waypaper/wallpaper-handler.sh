#!/bin/bash
# A script to handle color generation and hooks for waypaper
wallpaper="$1"
mode=$(gsettings get org.gnome.desktop.interface color-scheme)

if [ -f "$HOME/.local/state/yosemite/color_index" ]; then
    color_index=$(cat ~/.local/state/yosemite/color_index)
else
    echo "0" > ~/.local/state/yosemite/color_index
    color_index=0
fi

if [ -f "$HOME/.local/state/yosemite/scheme" ]; then
    scheme=$(cat ~/.local/state/yosemite/scheme)
  else
    scheme="scheme-tonal-spot"
    echo "scheme-tonal-spot" > ~/.local/state/yosemite/scheme
fi

if [ "$mode" = "'prefer-dark'" ]; then
    matugen image $wallpaper -t "$scheme" -m dark --source-color-index "$color_index"
else
    matugen image $wallpaper -t "$scheme" -m light --source-color-index "$color_index"
fi

# Store wallpaper path in a state file
echo "$wallpaper" > ~/.local/state/yosemite/wallpaper_path