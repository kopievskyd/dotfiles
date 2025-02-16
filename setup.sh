#!/bin/sh

CONFIG_DIR="$(pwd)"
FONT_DIR="$HOME/Library/Fonts"

# Install Homebrew if not present
install_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo "Homebrew installation complete"
    else
        echo "Homebrew already installed"
    fi
}

# Create all required symlinks
create_symlinks() {
    stow --no-folding --restow */
}

# Install packages from Brewfile
install_brew_packages() {
    echo "Installing formulae and casks from Brewfile..."
    brew bundle --global
    brew cleanup --prune=all
    rm -rf "$(brew --cache)"
}

# Install Node.js
install_nodejs() {
    if ! command -v fnm >/dev/null 2>&1; then
        echo "Installing fnm (Fast Node Manager)..."
        brew install fnm
    else
        echo "fnm is already installed"
    fi
    eval "$(fnm env --use-on-cd --shell zsh)"
    echo "Installing the latest LTS version of Node.js..."
    fnm install --lts
    echo "Node.js installation complete. Current version: $(node -v)"
}


# Install JetBrains Mono font
install_jetbrains_mono() {
    TEMP_DIR=$(mktemp -d)
    echo "Downloading JetBrains Mono..."
    LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest |
    grep "browser_download_url.*JetBrainsMono-[0-9.]*.zip" | cut -d '"' -f 4)
    if [ -z "$LATEST_RELEASE_URL" ]; then
        echo "Error: Could not find the latest version of JetBrains Mono"
        rm -rf "$TEMP_DIR"
        return 1
    fi
    curl -L -o "$TEMP_DIR/JetBrainsMono.zip" "$LATEST_RELEASE_URL"
    unzip -q "$TEMP_DIR/JetBrainsMono.zip" -d "$TEMP_DIR"
    TTF_DIR=$(find "$TEMP_DIR" -type d -name "ttf" | head -n 1)
    if [ -z "$TTF_DIR" ]; then
        echo "Error: TTF folder not found"
        rm -rf "$TEMP_DIR"
        return 1
    fi
    mkdir -p "$FONT_DIR"
    cp "$TTF_DIR"/JetBrainsMono-*.ttf "$FONT_DIR/"
    rm -rf "$TEMP_DIR"
    echo "JetBrains Mono fonts installed successfully"
}

# Macos defaults setup
macos_defaults_setup() {
    defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/.config/hammerspoon/init.lua"
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
    defaults write com.apple.dock autohide-delay -float 0 && \ killall Dock
}

# Main setup
echo "Starting setup..."
install_homebrew
create_symlinks
install_brew_packages
install_nodejs
install_jetbrains_mono
macos_defaults_setup
touch "$HOME/.hushlogin"
echo "Setup complete!"
