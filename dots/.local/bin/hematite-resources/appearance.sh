#!/bin/bash

operation=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    toggle)
      operation=toggle
      shift
      ;;
    *)
      wallpaper="$1"
      shift
      ;;
  esac
done

if [ "$operation" == "toggle" ]; then
  # Get wallpaper path from state file
  if [ -f ~/.local/state/quickshell/hematite/wallpaper_path ]; then
    wallpaper=$(cat ~/.local/state/quickshell/hematite/wallpaper_path)
  else
    echo "Creating nonexistent wallpaper state file with default wallpaper path."
    mkdir -p ~/.local/state/quickshell/hematite
    echo "$HOME/dotfiles/assets/default_wallpaper.jpg" > ~/.local/state/quickshell/hematite/wallpaper_path
    wallpaper="$HOME/dotfiles/assets/default_wallpaper.jpg"
    echo "Created state file. You might have to reset your wallpaper if you want correct colors."
  fi

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

  currentTheme=$(gsettings get org.gnome.desktop.interface color-scheme | tr -d "'")
  echo "Current theme: $currentTheme"
  if [[ "$currentTheme" = "prefer-dark" ]]; then
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
    matugen image "$wallpaper" -t "$scheme" -m light --source-color-index "$color_index"
    echo "Switched to light appearance."
  else
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    matugen image "$wallpaper" -t "$scheme" -m dark --source-color-index "$color_index"
    echo "Switched to dark appearance."
  fi
else
  echo "No valid operation specified. Use 'toggle' to switch appearances."
fi