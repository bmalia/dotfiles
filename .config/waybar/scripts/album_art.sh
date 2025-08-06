#! /bin/bash
album_art=$(playerctl -p cider metadata mpris:artUrl)
if [[ -z "$album_art" ]]; then
    exit
fi
curl -s "${album_art}" --output "/tmp/cover.jpeg"
echo "/tmp/cover.jpeg"