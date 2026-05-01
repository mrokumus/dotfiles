#!/usr/bin/env bash
set -euo pipefail

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RESET="\033[0m"

echo -e "${CYAN}==> Checking for Homebrew...${RESET}"
if ! command -v brew >/dev/null 2>&1; then
  echo -e "${YELLOW}Homebrew not found. Installing...${RESET}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo -e "${GREEN}Homebrew installed.${RESET}"
  echo -e "${CYAN}==> Copying ZSH configuration...${RESET}"
  if [[ -f ~/.config/zsh/main_zprofile ]]; then
    cp ~/.config/zsh/main_zprofile ~/.zprofile
    echo -e "${GREEN}ZSH profile copied to ~/.zprofile${RESET}"
  else
    echo -e "${YELLOW}Warning: ~/.config/zsh/main_zprofile not found. Skipping copy.${RESET}"
  fi
else
  echo -e "${GREEN}Homebrew already installed.${RESET}"
fi

echo -e "${CYAN}==> Updating Homebrew...${RESET}"
brew update

echo -e "${CYAN}==> Installing CLI tools...${RESET}"
brew install \
  git go nvm neovim tmux bat btop git-delta php starship eza composer node stats 

echo -e "${CYAN}==> Installing GUI applications...${RESET}"
brew install --cask \
  alacritty \
  firefox \
  google-chrome \
  karabiner-elements \
  rectangle \
  visual-studio-code \
  appcleaner \
  flycut \
  mullvad-vpn \
  whatsapp \
  bitwarden \
  font-d2coding-nerd-font \
  # phpstorm \
  spotify \
  discord \
  postman \
  # tableplus \
  zed
  
echo -e "${CYAN}==> Cleaning up...${RESET}"
brew cleanup


echo "==> Setting fast keyboard repeat..."
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 10
defaults write -g ApplePressAndHoldEnabled -bool false
killall SystemUIServer || true

echo -e "${GREEN}✅ Setup complete!${RESET}"
