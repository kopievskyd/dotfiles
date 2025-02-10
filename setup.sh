#!/bin/sh

CONFIG_DIR="$(pwd)"
COMPLETION_DIR="$CONFIG_DIR/zsh/completion"
BREWFILE_PATH="$CONFIG_DIR/brew/Brewfile"
FONT_DIR="$HOME/Library/Fonts"

# Create symlink and its parent directory if needed
symlink() {
    mkdir -p "$(dirname "$2")"
    ln -sf "$1" "$2" && echo "Created symlink: $1 -> $2" || echo "Failed to create symlink: $1 -> $2"
}

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
    # Create symlinks for zsh completion files
    for file in "$COMPLETION_DIR"/*; do
        symlink "$file" "$HOME/.config/zsh/completion/$(basename "$file")"
    done

    # Create symlinks for config files
    symlink "$CONFIG_DIR/zsh/.zshenv" "$HOME/.zshenv"
    symlink "$CONFIG_DIR/zsh/.zshrc" "$HOME/.config/zsh/.zshrc"
    symlink "$CONFIG_DIR/zsh/.p10k.zsh" "$HOME/.config/zsh/.p10k.zsh"
    symlink "$CONFIG_DIR/git/config" "$HOME/.config/git/config"
    symlink "$CONFIG_DIR/git/ignore" "$HOME/.config/git/ignore"
    symlink "$CONFIG_DIR/vim/vimrc" "$HOME/.config/vim/vimrc"
    symlink "$CONFIG_DIR/ghostty/config" "$HOME/.config/ghostty/config"
    symlink "$CONFIG_DIR/hammerspoon/init.lua" "$HOME/.config/hammerspoon/init.lua"
    symlink "$CONFIG_DIR/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
}

# Install packages from Brewfile
install_brew_packages() {
    if [ -f "$BREWFILE_PATH" ]; then
        echo "Installing formulae and casks from Brewfile..."
        brew bundle --file="$BREWFILE_PATH"
        brew cleanup --prune=all
        rm -rf "$(brew --cache)"
    else
        echo "No Brewfile found at $BREWFILE_PATH"
    fi
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
        grep "browser_download_url.*JetBrainsMono-[0-9.]*.zip" |
        cut -d '"' -f 4)

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
    defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
    defaults write com.apple.dock autohide-delay -float 0 && \
    killall Dock
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