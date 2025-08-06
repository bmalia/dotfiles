#!/bin/bash

COLORS_FILE="$HOME/.config/Equicord/themes/matugen/colors.txt"
CSS_FILE="$HOME/.config/Equicord/themes/Material-Discord.theme.css"

# Extract HSL values from colors.txt
HSL=$(grep -oP 'hsl\(\K[0-9]+,\s*[0-9.]+%,\s*[0-9.]+%' "$COLORS_FILE")
IFS=',' read -r HUE SAT LIGHT <<< "$HSL"

# Trim whitespace
HUE=$(echo "$HUE" | xargs)
SAT=$(echo "$SAT" | xargs)
LIGHT=$(echo "$LIGHT" | xargs)

# Update the CSS variables in the file
sed -i -E "s/(--accent-hue:\s*)[0-9]+;/\1$HUE;/" "$CSS_FILE"
sed -i -E "s/(--accent-saturation:\s*)[0-9.]+%;/\1$SAT;/" "$CSS_FILE"
# sed -i -E "s/(--accent-lightness:\s*)[0-9.]+%;/\1$LIGHT;/" "$CSS_FILE"