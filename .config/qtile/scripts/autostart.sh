#!/usr/bin/env bash

# Start a process only if an identical one is not already running
run() {
    pgrep -fx "$*" > /dev/null || "$@" &
}

run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
run dunst
run mpd
run picom --config "$HOME/.config/picom/picom.conf"
run xfce4-power-manager
run udiskie --tray --notify

nitrogen --set-zoom-fill --random "$HOME/lwalpapers/wallpapers"
