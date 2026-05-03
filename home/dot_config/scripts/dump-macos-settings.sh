#!/usr/bin/env bash
set -euo pipefail

section() {
  printf '\n## %s\n\n' "$1"
}

read_default() {
  local domain="$1"
  local key="$2"
  local scope="${3:-normal}"

  if [[ "$scope" == "currentHost" ]]; then
    printf '%-55s ' "defaults -currentHost read $domain $key"
    defaults -currentHost read "$domain" "$key" 2>/dev/null || true
  else
    printf '%-55s ' "defaults read $domain $key"
    defaults read "$domain" "$key" 2>/dev/null || true
  fi
}

section "System"
sw_vers || true
printf 'Host: '; hostname || true
printf 'User: '; whoami || true

section "Trackpad / Mouse"
read_default NSGlobalDomain com.apple.mouse.tapBehavior
read_default NSGlobalDomain com.apple.mouse.tapBehavior currentHost
read_default com.apple.AppleMultitouchTrackpad Clicking
read_default com.apple.AppleMultitouchTrackpad Clicking currentHost
read_default com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking
read_default com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking currentHost
read_default NSGlobalDomain com.apple.trackpad.scaling
read_default NSGlobalDomain com.apple.swipescrolldirection
read_default NSGlobalDomain com.apple.mouse.scaling
read_default NSGlobalDomain com.apple.scrollwheel.scaling

section "Keyboard"
read_default NSGlobalDomain KeyRepeat
read_default NSGlobalDomain InitialKeyRepeat
read_default NSGlobalDomain ApplePressAndHoldEnabled
read_default NSGlobalDomain com.apple.keyboard.fnState
read_default NSGlobalDomain AppleKeyboardUIMode
read_default NSGlobalDomain NSAutomaticSpellingCorrectionEnabled
read_default NSGlobalDomain NSAutomaticCapitalizationEnabled
read_default NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled
read_default NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled
read_default NSGlobalDomain NSAutomaticDashSubstitutionEnabled

section "Dock"
read_default com.apple.dock autohide
read_default com.apple.dock tilesize
read_default com.apple.dock orientation
read_default com.apple.dock show-recents
read_default com.apple.dock mru-spaces
read_default com.apple.dock expose-group-apps
read_default com.apple.dock mineffect
read_default com.apple.dock minimize-to-application

section "Finder"
read_default com.apple.finder AppleShowAllFiles
read_default NSGlobalDomain AppleShowAllExtensions
read_default com.apple.finder FXPreferredViewStyle
read_default com.apple.finder ShowPathbar
read_default com.apple.finder ShowStatusBar
read_default com.apple.finder _FXShowPosixPathInTitle
read_default com.apple.finder FXDefaultSearchScope
read_default com.apple.finder FXEnableExtensionChangeWarning
read_default com.apple.finder QuitMenuItem

section "Screenshots"
read_default com.apple.screencapture location
read_default com.apple.screencapture type
read_default com.apple.screencapture disable-shadow
read_default com.apple.screencapture show-thumbnail

section "Global UI"
read_default NSGlobalDomain AppleInterfaceStyle
read_default NSGlobalDomain AppleShowScrollBars
read_default NSGlobalDomain NSNavPanelExpandedStateForSaveMode
read_default NSGlobalDomain NSNavPanelExpandedStateForSaveMode2
read_default NSGlobalDomain PMPrintingExpandedStateForPrint
read_default NSGlobalDomain PMPrintingExpandedStateForPrint2

section "Desktop Services"
read_default com.apple.desktopservices DSDontWriteNetworkStores
read_default com.apple.desktopservices DSDontWriteUSBStores

section "Menu Bar / Control Center"
read_default com.apple.controlcenter BatteryShowPercentage
read_default com.apple.menuextra.clock DateFormat

section "Flycut"
read_default com.generalarcade.flycut rememberNum
read_default com.generalarcade.flycut removeDuplicates
read_default com.generalarcade.flycut menuIcon
read_default com.generalarcade.flycut suppressAccessibilityAlert

section "Stats"
read_default eu.exelban.Stats CPU_widget
read_default eu.exelban.Stats GPU_widget
read_default eu.exelban.Stats GPU_state
read_default eu.exelban.Stats Battery_widget
read_default eu.exelban.Stats Battery_battery_additional
read_default eu.exelban.Stats Battery_battery_color
read_default eu.exelban.Stats CombinedModules
read_default eu.exelban.Stats CombinedModules_spacing
read_default eu.exelban.Stats dockIcon
read_default eu.exelban.Stats temperature_units
read_default eu.exelban.Stats LaunchAtLoginNext

section "Login Items / Background Items"
osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null || true

section "Karabiner files"
ls -la "$HOME/.config/karabiner" 2>/dev/null || true

section "Dotfiles-managed config dirs"
find "$HOME/.config" -maxdepth 1 -type d | sort | sed "s#$HOME/##" || true
