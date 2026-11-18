#!/usr/bin/env bash

# Start a process only if an identical one is not already running
run() {
    local name="${1##*/}"
    # The kernel truncates process names to 15 chars, so compare the truncated name
    pgrep -u "$USER" -x "${name:0:15}" > /dev/null || "$@" &
}
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
run dunst
run picom --config "$HOME/.config/picom/picom.conf"
run xfce4-power-manager
run udiskie --tray --notify

WALLPAPERS="$HOME/lwalpapers/wallpapers"
[ -d "$WALLPAPERS" ] && nitrogen --set-zoom-fill --random "$WALLPAPERS"
