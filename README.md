# dotfiles (hnxzl)

Arch Linux + Hyprland (Wayland), config Lua, plugin HyprGlass (liquid glass).

## Struktur

Tiap folder adalah satu paket GNU Stow:

```
hypr/.config/hypr/...      -> ~/.config/hypr
waybar/.config/waybar/...  -> ~/.config/waybar
packages/pkglist.txt       daftar paket resmi (pacman)
packages/aur-pkglist.txt   daftar paket AUR
backup.sh                  salin ~/.config -> repo, simpan daftar paket, scan secret
install.sh                 pasang paket + stow + plugin Hyprland
```

## Update repo dari laptop yang sedang dipakai

```bash
cd ~/dotfiles
./backup.sh
git add -A && git commit -m "update dotfiles" && git push
```

## Instalasi di Arch baru

Setelah install Arch dasar dan user biasa:

```bash
sudo pacman -S --needed git
git clone https://github.com/hnxzl/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Lalu login ke Hyprland dan pasang plugin kalau belum otomatis:

```bash
hyprpm update
hyprpm add https://github.com/hyprnux/hyprglass
hyprpm enable hyprglass
hyprctl hyprglass status
```

## Catatan

- Config lama yang bentrok dipindah ke `*.pre-dotfiles`, bukan dihapus.
- Plugin Hyprland sensitif versi. Setelah update Hyprland jalankan `hyprpm update`.
- Nama monitor, resolusi, dan GPU env bisa beda per mesin. Cek `hypr/.config/hypr` bagian monitor.
- Jangan commit token atau password. `backup.sh` menjalankan scan sederhana, tapi tetap cek manual.
