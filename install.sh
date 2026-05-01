#!/usr/bin/env bash
set -euo pipefail

RED="\033[31m"
GREEN="\033[32m"
CYAN="\033[36m"
BOLD="\033[1m"
RESET="\033[0m"

info() { echo -e "${CYAN}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}[OK]${RESET} $1"; }
error() { echo -e "${RED}[ERROR]${RESET} $1"; exit 1; }

OS="$(uname -s)"

# ─── Homebrew (macOS only) ───────────────────────────────────────────────────
install_homebrew() {
  if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    success "Homebrew installed"
  else
    success "Homebrew already installed"
  fi
}

# ─── Chezmoi ─────────────────────────────────────────────────────────────────
install_chezmoi() {
  if ! command -v chezmoi &>/dev/null; then
    info "Installing chezmoi..."
    if [[ "$OS" == "Darwin" ]]; then
      brew install chezmoi
    else
      sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
    fi
    success "chezmoi installed"
  else
    success "chezmoi already installed"
  fi
}

# ─── Apply dotfiles ─────────────────────────────────────────────────────────
apply_dotfiles() {
  info "Initializing dotfiles with chezmoi..."
  chezmoi init --ssh --apply mrokumus
  success "Dotfiles applied"
}

# ─── macOS packages ─────────────────────────────────────────────────────────
install_mac_packages() {
  info "Installing packages from Brewfile..."
  brew bundle --file="$HOME/.Brewfile" --no-lock
  success "Brewfile packages installed"
}

# ─── Arch Linux packages ────────────────────────────────────────────────────
install_arch_packages() {
  if [[ -f "$HOME/packages-arch.txt" ]]; then
    info "Installing Arch packages..."
    sudo pacman -S --needed --noconfirm - < "$HOME/packages-arch.txt"
    success "Arch packages installed"
  fi
}

# ─── Post-install ────────────────────────────────────────────────────────────
post_install() {
  # zsh as default shell
  if [[ "$SHELL" != *"zsh"* ]]; then
    info "Setting zsh as default shell..."
    chsh -s "$(which zsh)"
    success "Default shell set to zsh"
  fi
}

# ─── Main ────────────────────────────────────────────────────────────────────
main() {
  echo -e "${BOLD}${CYAN}"
  echo "  ╔══════════════════════════════════════╗"
  echo "  ║   mrokumus/dotfiles bootstrap        ║"
  echo "  ╚══════════════════════════════════════╝"
  echo -e "${RESET}"

  if [[ "$OS" == "Darwin" ]]; then
    info "Detected: macOS"
    install_homebrew
    install_chezmoi
    apply_dotfiles
    install_mac_packages
  elif [[ "$OS" == "Linux" ]]; then
    info "Detected: Linux"
    local distro_id=""
    [[ -f /etc/os-release ]] && distro_id=$(. /etc/os-release && echo "$ID")
    info "Distribution: ${distro_id:-unknown}"

    install_chezmoi
    apply_dotfiles

    case "$distro_id" in
      arch|cachyos|manjaro) install_arch_packages ;;
      *) info "Unknown distro, skipping package install" ;;
    esac
  else
    error "Unsupported OS: $OS"
  fi

  post_install
  success "Bootstrap complete!"
}

main "$@"
