# dotfiles

Cross-platform dotfiles managed with [chezmoi](https://chezmoi.io/).

## Supported environments

- **macOS** — personal + work (Jotform)
- **Arch Linux / CachyOS** — personal

## Quick start

```bash
# New machine bootstrap
curl -fsSL https://raw.githubusercontent.com/mrokumus/dotfiles/main/install.sh | bash

# Or manually
chezmoi init --ssh --apply mrokumus
```

## Structure

Source files live under `home/` (see `.chezmoiroot`). OS-specific behaviour
is controlled by `.chezmoiignore` and template (`.tmpl`) files.

### File map

| Path | Category | Description |
|---|---|---|
| `dot_config/starship/` | common | Starship prompt (Catppuccin Frappé) |
| `dot_config/nvim/` | common | Neovim config (Lazy.nvim) |
| `dot_config/btop/` | common | btop system monitor |
| `dot_config/git/` | common | Git config (delta, global ignore) |
| `dot_config/gh/` | common | GitHub CLI preferences |
| `dot_config/scripts/` | common | Utility scripts |
| `dot_config/zed/` | common | Zed editor settings + snippets |
| `dot_config/zsh/` | mixed | Zsh config (`.tmpl` for OS paths) |
| `dot_config/alacritty/` | mixed | Alacritty terminal (`.tmpl` for OS diffs) |
| `dot_config/tmux/` | mixed | Tmux config (plugins via external) |
| `dot_config/private_karabiner/` | darwin-only | Karabiner-Elements (Cmd/Ctrl swap, hjkl) |
| `dot_config/keyd/` | linux-only | keyd (CapsLock, ISO key, hjkl) |
| `dot_Brewfile` | darwin-only | Homebrew packages |
| `dot_zshrc` | common | Root `.zshrc` (sources `~/.config/zsh`) |
| `run_onchange_darwin-defaults.sh.tmpl` | darwin-only | macOS system prefs + app defaults |
| `.chezmoiexternal.toml.tmpl` | — | Tmux plugins + Jotform private repo |
| `.chezmoiignore` | — | OS-based file filtering |

### Categories

- **common** — identical on all machines, no template
- **mixed** — present everywhere, content varies per OS (`.tmpl`)
- **darwin-only** — ignored on Linux via `.chezmoiignore`
- **linux-only** — ignored on macOS via `.chezmoiignore`

### Keyboard layout

Consistent across macOS and Linux:

| Feature | macOS (Karabiner) | Linux (keyd) |
|---|---|---|
| CapsLock tap | Esc | Esc |
| CapsLock hold | Ctrl | Ctrl |
| Cmd ↔ Ctrl | Swapped (Linux-like shortcuts) | Native |
| Right Cmd + hjkl | Arrow keys | Arrow keys |
| ISO key | Tilde (`~`) | Tilde (`~`) |

### Daily workflow

```bash
# Edit a config
chezmoi edit ~/.config/starship/starship.toml

# Apply changes locally
chezmoi apply

# Commit and push
chezmoi cd
git add . && git commit -m "update" && git push
exit

# Pull on another machine
chezmoi update
```
