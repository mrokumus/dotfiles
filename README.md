# dotfiles

Cross-platform dotfiles managed with [chezmoi](https://chezmoi.io/).

## Quick start

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply mrokumus
```

## Structure

Source files live under `home/` (see `.chezmoiroot`). OS-specific behaviour is controlled by `home/.chezmoiignore` and template (`*.tmpl`) files.

