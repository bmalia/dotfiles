#!/bin/bash

while true; do
    album_art=$(playerctl metadata mpris:artUrl)
    if [[ -n "$album_art" ]]; then
        break
    fi
    sleep 0.1
done

curl -s "${album_art}" --output "/tmp/cover.jpeg"

status=$(gsettings get org.gnome.desktop.interface color-scheme | tr -d "'")

if [ "$status" = "prefer-dark" ]; then
    matugen image /tmp/cover.jpeg -c ~/.config/matugen/qs-media.toml -m dark
else
    matugen image /tmp/cover.jpeg -c ~/.config/matugen/qs-media.toml -m light
fi