# dotfiles

Minimal, modern Arch Linux desktop: Qtile (X11) + Picom + Alacritty + Fish, themed with Rosé Pine Moon.

> Never commit tokens, SSH keys or `.env` files.

## Stack

| Component     | Choice                                   |
| ------------- | ---------------------------------------- |
| OS            | Arch Linux                               |
| Window manager| Qtile (X11)                              |
| Compositor    | Picom (`picom-git`, GLX backend)         |
| Terminal      | Alacritty                                |
| Shell         | Fish + Starship                          |
| Fonts         | JetBrains Mono Nerd Font, Inter          |
| Notifications | Dunst                                    |
| Wallpapers    | Nitrogen                                 |
| AUR helper    | yay                                      |
| Palette       | Rosé Pine Moon                           |

## How it is stored

This is a **bare repository** at `~/.dotfiles` whose work tree is `$HOME`.
No symlinks, no install script: files live exactly where the programs expect them.

```
~/README.md
~/.config/
├── qtile/             config.py, settings/, scripts/autostart.sh
├── picom/picom.conf
├── alacritty/         alacritty.toml, rose-pine-moon.toml
├── fish/config.fish
├── starship.toml
└── arch-setup/        pkglist-native.txt, pkglist-aur.txt
```

## Daily usage

The `dotfiles` alias is defined in `config.fish`:

```fish
dotfiles status
dotfiles add ~/.config/picom/picom.conf
dotfiles commit -m "Tweak picom blur"
dotfiles push
```

## Restore on a new machine

Start from a fresh Arch install with your user created and network working.

### 1. Base tools and yay

```bash
sudo pacman -S --needed git base-devel fish
git clone https://aur.archlinux.org/yay.git /tmp/yay
(cd /tmp/yay && makepkg -si)
```

### 2. Clone the bare repository

```bash
git clone --bare https://github.com/tomychi/dotfiles.git "$HOME/.dotfiles"
alias dotfiles='git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'
dotfiles config status.showUntrackedFiles no
```

### 3. Check out the files (backing up conflicts)

```bash
mkdir -p "$HOME/.dotfiles-backup"
if ! dotfiles checkout 2>/dev/null; then
    dotfiles checkout 2>&1 | grep -E "^\s+\." | awk '{print $1}' | while read -r f; do
        mkdir -p "$HOME/.dotfiles-backup/$(dirname "$f")"
        mv "$HOME/$f" "$HOME/.dotfiles-backup/$f"
    done
    dotfiles checkout
fi
```

### 4. Install packages

Review both lists first: they were generated on the original machine and may
include hardware-specific packages (microcode, GPU drivers, bootloader).

```bash
sudo pacman -S --needed - < ~/.config/arch-setup/pkglist-native.txt
yay -S --needed - < ~/.config/arch-setup/pkglist-aur.txt
```

### 5. Wallpapers

Wallpapers are **not** in this repository (binary files bloat the history).
They live in their own private repository:

```bash
git clone https://github.com/tomychi/wallpapers.git ~/lwalpapers/wallpapers
```

### 6. Finish

```bash
chsh -s /usr/bin/fish
```

Log out and start a Qtile session.

## Not tracked (set up manually)

- SSH keys, GitHub tokens, API credentials
- Wallpapers (separate repository)
- pnpm global data and the Google Cloud SDK (`~/google-cloud-sdk`)

## Maintenance

Refresh the package lists after installing or removing important software:

```bash
pacman -Qqen > ~/.config/arch-setup/pkglist-native.txt
pacman -Qqem > ~/.config/arch-setup/pkglist-aur.txt
dotfiles add ~/.config/arch-setup && dotfiles commit -m "Update package lists"
```

Look for hardcoded paths that would break under a different username:

```bash
grep -rn "/home/" ~/.config/qtile ~/.config/fish ~/.config/picom ~/.config/alacritty
```

## Hardware notes

- CPU/GPU: Ryzen 5 5600G with integrated Radeon Vega (Mesa, `radeonsi`)
- Monitors: HDMI-A-1 at native 1360x768, DisplayPort-0 at 1600x900
