#!/usr/bin/env bash
set -euo pipefail
declare -A apps=(
  [Telegram]="Telegram"
  [Brave]="brave"
  [Discord]="discord"
  [Spotify]="spotify"
)
declare -A labels=(
  [Telegram]="Telegram"
  [Brave]="Brave"
  [Discord]="Discord"
  [Spotify]="Spotify"
)
mapfile -t running < <(for app in "${!apps[@]}"; do pgrep -u "$USER" -x "${apps[$app]}" >/dev/null && printf "%s\n" "$app"; done | sort)
if ((${#running[@]} == 0)); then
  notify-send "Aplicaciones en segundo plano" "No se encontraron aplicaciones configuradas en ejecución."
  exit 0
fi
selected=$(printf "%s\n" "${running[@]}" | rofi -dmenu -i -p "Cerrar aplicación") || exit 0
[[ -n "$selected" ]] || exit 0
rofi -e "¿Cerrar $selected? Se terminará la aplicación y podrías perder trabajo sin guardar." || true
choice=$(printf "Cancelar\nCerrar aplicación" | rofi -dmenu -i -p "$selected") || exit 0
[[ "$choice" == "Cerrar aplicación" ]] || exit 0
case "$selected" in
  Telegram) pkill -TERM -u "$USER" -x Telegram ;;
  Brave) brave --disable-extensions >/dev/null 2>&1 & disown || true ;;
  Discord) pkill -TERM -u "$USER" -x discord ;;
  Spotify) pkill -TERM -u "$USER" -x spotify ;;
esac
notify-send "Aplicaciones" "Solicitud de cierre enviada a $selected."
