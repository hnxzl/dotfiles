# dotfiles (hnxzl)

Arch Linux + Hyprland (Wayland), Lua configuration, and the HyprGlass liquid-glass plugin.

## Structure

Each directory is a GNU Stow package:

```
hypr/.config/hypr/...      -> ~/.config/hypr
waybar/.config/waybar/...  -> ~/.config/waybar
packages/pkglist.txt       official pacman package list
packages/aur-pkglist.txt   AUR package list
backup.sh                  copy ~/.config into the repo, save package lists, scan for secrets
install.sh                 install packages, apply dotfiles with Stow, and configure the plugin
```

## Update the repository from the current laptop

```bash
cd ~/dotfiles
./backup.sh
git add -A && git commit -m "update dotfiles" && git push
```

## Install on a new Arch Linux system

After installing the base system and creating a regular user:

```bash
sudo pacman -S --needed git
git clone https://github.com/hnxzl/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Log in to Hyprland and install the plugin manually if it was not added automatically:

```bash
hyprpm update
hyprpm add https://github.com/hyprnux/hyprglass
hyprpm enable hyprglass
hyprctl hyprglass status
```

## Legacy Waybar presets

This repository includes three legacy Waybar layouts that can be selected and tried separately:

| Preset | Appearance | Best for |
|---|---|---|
| `modular` | Full JaKooLit layout with panels, workspaces, tray, and module groups | Legacy setups with many shortcuts and modules |
| `island` | A small, floating island bar centered at the top | A minimal appearance that still shows system information |
| `minimal` | A slim bar with workspaces, clock, tray, audio, network, and battery | Laptops or a clean desktop setup |

List the available presets and select one:

```bash
~/.config/waybar/scripts/select-waybar.sh list
~/.config/waybar/scripts/select-waybar.sh modular
~/.config/waybar/scripts/select-waybar.sh island
~/.config/waybar/scripts/select-waybar.sh minimal
```

The script copies the selected preset to `~/.config/waybar/config.jsonc` and `~/.config/waybar/style.css`, then restarts Waybar. The latest preset name is stored in `~/.local/state/waybar-preset`.

Minimum packages:

```bash
sudo pacman -S waybar swaync networkmanager pavucontrol
```

For laptops, make sure the battery module is supported by your kernel and hardware. The `modular` preset needs a Nerd Font and legacy scripts such as `$HOME/.config/hypr/scripts/WaybarScripts.sh` for some shortcut buttons. The `island` and `minimal` presets are more standalone.

## Notes

- Existing configurations that conflict with Stow are moved to `*.pre-dotfiles` instead of being deleted.
- The Hyprland plugin is version-sensitive. Run `hyprpm update` after updating Hyprland.
- Monitor names, resolution, and GPU environment variables may differ between machines. Check `hypr/.config/hypr/monitors.conf` and `hypr/.config/hypr/monitors.lua`.
- Never commit tokens or passwords. `backup.sh` performs a basic secret scan, but you should still review changes manually.
