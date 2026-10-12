#!/usr/bin/env bash
# Salin config dari ~/.config ke repo ini (struktur GNU Stow), simpan daftar paket,
# lalu scan kemungkinan secret. Jalankan dari dalam folder dotfiles.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

# Edit daftar ini sesuai kebutuhan. Folder yang tidak ada akan dilewati.
APPS=(
  hypr waybar rofi kitty foot alacritty ghostty
  quickshell swaync fastfetch gtk-3.0 gtk-4.0 fontconfig
)

for app in "${APPS[@]}"; do
  src="$CONFIG_DIR/$app"
  if [[ ! -d "$src" ]]; then
    echo "skip   $app (tidak ada)"
    continue
  fi
  dest="$REPO/$app/.config/$app"
  mkdir -p "$dest"
  rsync -a --delete \
    --exclude '*.bak' --exclude '*.bak.*' --exclude '*~' \
    --exclude '.cache' --exclude 'cache' \
    "$src/" "$dest/"
  echo "backup $app"
done

# Daftar paket
mkdir -p "$REPO/packages"
pacman -Qqen > "$REPO/packages/pkglist.txt"
pacman -Qqem > "$REPO/packages/aur-pkglist.txt" || true
echo "paket  $(wc -l < "$REPO/packages/pkglist.txt") resmi, $(wc -l < "$REPO/packages/aur-pkglist.txt") AUR"

# Scan secret sederhana
echo
echo "== Scan secret =="
if grep -rniE "(api[_-]?key|token|passw(or)?d|secret|bearer)\s*[:=]" \
     --exclude-dir=.git --exclude='*.sh' --exclude='README.md' "$REPO"; then
  echo
  echo "!! Ada baris yang mirip secret di atas. Cek dulu sebelum git push."
else
  echo "Tidak ada yang mencurigakan."
fi

echo
echo "Selesai. Lanjut: cd $REPO && git add -A && git commit -m 'update dotfiles' && git push"
