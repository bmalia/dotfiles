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
  currentTheme=$(gsettings get org.gnome.desktop.interface color-scheme | tr -d "'")
  echo "Current theme: $currentTheme"
  if [[ "$currentTheme" = "prefer-dark" ]]; then
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
    matugen image ~/current_wallpaper -t scheme-tonal-spot -m light
    echo "Switched to light appearance."
  else
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    matugen image ~/current_wallpaper -t scheme-tonal-spot -m dark
    echo "Switched to dark appearance."
  fi
else
  echo "No valid operation specified. Use 'toggle' to switch appearances."
fi