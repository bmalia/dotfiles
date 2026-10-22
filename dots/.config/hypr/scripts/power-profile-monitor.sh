#!/usr/bin/env bash
# Power Profile Monitor for Hyprland
# Watches for system power profile changes and dynamically updates blur settings
# Run this as a background service (e.g., in your Hyprland autostart)

set -euo pipefail

# Configurations
CHECK_INTERVAL=2
DBUS_PATH="/net/hadess/PowerProfiles"
DBUS_INTERFACE="net.hadess.PowerProfiles"
DBUS_PROPERTY="ActiveProfile"
KITTY_CONFIG_FILE="${HOME}/.config/kitty/power-profile.conf"

# Logging
log() {
    echo "$*"
}

get_power_profile() {
    dbus-send --system --print-reply \
        --dest="$DBUS_INTERFACE" \
        "$DBUS_PATH" \
        "org.freedesktop.DBus.Properties.Get" \
        string:"$DBUS_INTERFACE" \
        string:"$DBUS_PROPERTY" 2>/dev/null \
        | grep -o 'string "[^"]*"' \
        | head -n 1 \
        | sed 's/^string "\(.*\)"$/\1/' \
        || echo "unknown"
}

update_kitty_opacity() {
    local profile="$1"
    local opacity="0.85"

    if [[ "$profile" == "power-saver" ]]; then
        opacity="1.0"
    fi

    mkdir -p "$(dirname "$KITTY_CONFIG_FILE")"
    cat > "$KITTY_CONFIG_FILE" <<EOF
background_opacity $opacity
dynamic_background_opacity no
EOF

    if command -v kitty &>/dev/null; then
        kitty @ set-background-opacity "$opacity" 2>/dev/null || true
    fi
}

# Update blur setting in Hyprland via hyprctl
update_settings() {
    local profile="$1"
    local enabled="false"
    
    if [[ "$profile" != "power-saver" ]]; then
        enabled="true"
    fi
    
    if command -v hyprctl &> /dev/null; then
        hyprctl eval "hl.config({decoration = {blur = {
            enabled = $enabled
        }, shadow = { enabled = $enabled}} })" && \
            log "Updated transparency to $enabled for profile: $profile" || \
            log "Failed to update blur setting for profile: $profile"
    else
        log "hyprctl not found in PATH"
    fi
}

monitor_power_profile() {
    log "Starting power profile monitor (polling method)"

    local last_profile=""

    while true; do
        local profile
        profile="$(get_power_profile)"

        if [[ -n "$profile" && "$profile" != "$last_profile" ]]; then
            last_profile="$profile"
            log "Power profile changed to: $profile"
            update_settings "$profile"
            update_kitty_opacity "$profile"
        fi

        sleep "$CHECK_INTERVAL"
    done
}

# Main
main() {
    log "Power profile monitor started"
    monitor_power_profile
}
trap 'log "Power profile monitor stopped"' EXIT
main "$@"