#!/usr/bin/env bash
# Pasang paket dan symlink dotfiles di Arch Linux baru.
# Pakai: ./install.sh          (paket + stow + plugin)
#        ./install.sh --no-pkgs (lewati instalasi paket)
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO"

INSTALL_PKGS=1
[[ "${1:-}" == "--no-pkgs" ]] && INSTALL_PKGS=0

# 1. Paket
if [[ $INSTALL_PKGS -eq 1 ]]; then
  sudo pacman -S --needed --noconfirm git stow base-devel

  if [[ -s packages/pkglist.txt ]]; then
    sudo pacman -S --needed - < packages/pkglist.txt
  fi

  if [[ -s packages/aur-pkglist.txt ]]; then
    if ! command -v yay >/dev/null; then
      tmp="$(mktemp -d)"
      git clone https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"
      (cd "$tmp/yay-bin" && makepkg -si --noconfirm)
      rm -rf "$tmp"
    fi
    yay -S --needed - < packages/aur-pkglist.txt
  fi
fi

# 2. Symlink config dengan stow
for dir in */; do
  name="${dir%/}"
  [[ -d "$name/.config" ]] || continue
  # pindahkan config bawaan yang bentrok supaya stow tidak error
  for target in "$name"/.config/*; do
    dest="$HOME/.config/$(basename "$target")"
    if [[ -e "$dest" && ! -L "$dest" ]]; then
      mv "$dest" "$dest.pre-dotfiles"
      echo "pindah $dest -> $dest.pre-dotfiles"
    fi
  done
  stow -t "$HOME" "$name"
  echo "stow   $name"
done

# 3. Plugin Hyprland (butuh Hyprland sudah jalan, jalankan dari sesi Hyprland)
if command -v hyprpm >/dev/null && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  hyprpm update || true
  hyprpm add https://github.com/hyprnux/hyprglass || true
  hyprpm enable hyprglass || true
else
  echo
  echo "Lewati plugin Hyprland (belum di sesi Hyprland). Nanti jalankan:"
  echo "  hyprpm update"
  echo "  hyprpm add https://github.com/hyprnux/hyprglass && hyprpm enable hyprglass"
fi

echo
echo "Selesai. Logout lalu login ulang ke Hyprland, lalu cek: hyprctl hyprglass status"
