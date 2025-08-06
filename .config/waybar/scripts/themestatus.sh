#!/bin/bash
status=$(gsettings get org.gnome.desktop.interface color-scheme | tr -d "'")

if [ "$status" = "prefer-dark" ]; then
    echo " "
else
    echo " "
fi

