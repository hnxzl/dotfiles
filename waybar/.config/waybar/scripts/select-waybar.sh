#!/usr/bin/env bash
set -euo pipefail

WAYBAR_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"
PRESET="${1:-list}"

usage() {
  echo "Pakai: select-waybar.sh <modular|island|minimal|list>"
}

case "$PRESET" in
  modular|island|minimal) ;;
  list)
    echo "Preset Waybar lama yang tersedia:"
    echo "  modular  - layout penuh/JaKooLit"
    echo "  island   - layout island dengan clock tengah"
    echo "  minimal  - bar compact dengan workspace dan system drawer"
    usage
    exit 0
    ;;
  *)
    usage
    exit 2
    ;;
esac

PRESET_DIR="$WAYBAR_DIR/presets/$PRESET"
[[ -f "$PRESET_DIR/config.jsonc" && -f "$PRESET_DIR/style.css" ]] || {
  echo "Preset tidak lengkap: $PRESET"
  exit 1
}

mkdir -p "$WAYBAR_DIR/scripts"
cp "$PRESET_DIR/config.jsonc" "$WAYBAR_DIR/config.jsonc"
cp "$PRESET_DIR/style.css" "$WAYBAR_DIR/style.css"

if [[ "$PRESET" == "modular" && -d "$PRESET_DIR/support" ]]; then
  cp "$PRESET_DIR/support/"* "$WAYBAR_DIR/"
fi

if command -v waybar >/dev/null; then
  while read -r pid; do
    [[ -n "$pid" ]] && kill "$pid" 2>/dev/null || true
  done < <(pgrep -x waybar || true)
  nohup waybar -c "$WAYBAR_DIR/config.jsonc" -s "$WAYBAR_DIR/style.css" >/tmp/waybar-dotfiles.log 2>&1 &
else
  echo "Waybar belum terpasang. Jalankan: sudo pacman -S waybar"
  exit 1
fi

mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}"
printf '%s\n' "$PRESET" > "${XDG_STATE_HOME:-$HOME/.local/state}/waybar-preset"
echo "Waybar preset '$PRESET' aktif. Log: /tmp/waybar-dotfiles.log"
