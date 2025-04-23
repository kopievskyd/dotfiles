#!/bin/sh

# Define paths
REPO_DIR="$HOME/Developer/dotfiles"
FONT_DIR="$HOME/Library/Fonts"
BREWFILE_PATH="$REPO_DIR/homebrew/.config/homebrew/Brewfile"

# Clone dotfiles repo
clone_repo() {
    echo "Checking dotfiles repository..."

    if [ ! -d "$REPO_DIR" ]; then
        echo "Cloning dotfiles repository..."
        git clone "https://github.com/kopievskyd/dotfiles.git" "$REPO_DIR"
        [ $? -ne 0 ] && return 1
        echo "Repository cloned successfully!"
    else
        echo "Dotfiles repository already exists. Pulling latest changes..."
        git -C "$REPO_DIR" pull
        [ $? -ne 0 ] && return 1
        echo "Repository updated successfully!"
    fi

    if [ "$(pwd)" != "$REPO_DIR" ]; then
        echo "Changing directory to $REPO_DIR..."
        cd "$REPO_DIR" || return 1
        exec sh setup.sh
    fi
}

# Install Homebrew if not present
install_homebrew() {
    echo "Checking Homebrew installation..."

    if ! command -v brew >/dev/null 2>&1; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        [ $? -ne 0 ] && return 1
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo "Homebrew installed successfully!"
    else
        echo "Homebrew already installed!"
    fi
}

# Install packages from Brewfile
install_brew_packages() {
    echo "Checking Brewfile..."

    if [ -f "$BREWFILE_PATH" ]; then
        echo "Installing formulae and casks from Brewfile..."
        brew bundle --file="$BREWFILE_PATH"
        if [ $? -ne 0 ]; then
            echo "Warning: Some packages might not have installed correctly."
        else
            echo "All packages installed successfully!"
        fi

        echo "Cleaning up Homebrew cache..."
        brew cleanup --prune=all
        rm -rf "$(brew --cache)"
        echo "Cleanup complete!"
    else
        echo "No Brewfile found at $BREWFILE_PATH!"
        return 1
    fi
}

# Create all required symlinks
create_symlinks() {
    echo "Creating symbolic links with GNU stow..."

    # Check if stow is installed
    if ! command -v stow >/dev/null 2>&1; then
        echo "GNU stow is not installed!"
        return 1
    fi

    # Create symlinks for each directory
    stow */
    [ $? -ne 0 ] && return 1

    echo "Symbolic links created successfully!"
}

# Install Node.js
install_nodejs() {
    echo "Setting up Node.js environment..."

    if ! command -v fnm >/dev/null 2>&1; then
        echo "Installing Fast Node Manager (fnm)..."
        brew install fnm
        [ $? -ne 0 ] && return 1
        echo "Fast Node Manager (fnm) installed successfully!"
    else
        echo "Fast Node Manager (fnm) is already installed!"
    fi

    echo "Setting up Fast Node Manager (fnm) environment..."
    eval "$(fnm env --use-on-cd --shell zsh)"

    echo "Installing the latest LTS version of Node.js..."
    fnm install --lts
    [ $? -ne 0 ] && return 1

    echo "Node.js installation complete. Current version: $(node -v)"
}

# Install JetBrains Mono font
install_jetbrains_mono() {
    echo "Setting up JetBrains Mono font..."

    # Check if fonts are already installed
    if [ -f "$FONT_DIR/JetBrainsMono-Regular.ttf" ]; then
        echo "JetBrains Mono fonts already installed!"
        return 0
    fi

    TEMP_DIR=$(mktemp -d)
    echo "Downloading JetBrains Mono..."

    LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest |
        grep "browser_download_url.*JetBrainsMono-[0-9.]*.zip" |
    cut -d '"' -f 4)

    if [ -z "$LATEST_RELEASE_URL" ]; then
        rm -rf "$TEMP_DIR"
        return 1
    fi

    curl -L -o "$TEMP_DIR/JetBrainsMono.zip" "$LATEST_RELEASE_URL"
    [ $? -ne 0 ] && { rm -rf "$TEMP_DIR"; return 1; }

    echo "Extracting font files..."
    unzip -q "$TEMP_DIR/JetBrainsMono.zip" -d "$TEMP_DIR"

    TTF_DIR=$(find "$TEMP_DIR" -type d -name "ttf" | head -n 1)
    [ $? -ne 0 ] && { rm -rf "$TEMP_DIR"; return 1; }

    echo "Installing font files to $FONT_DIR..."
    mkdir -p "$FONT_DIR"
    cp "$TTF_DIR"/JetBrainsMono-*.ttf "$FONT_DIR/"

    rm -rf "$TEMP_DIR"
    echo "JetBrains Mono fonts installed successfully!"
}

# macOS defaults setup
macos_defaults_setup() {
    echo "Configuring macOS defaults..."

    # Hammerspoon config location
    echo "Setting Hammerspoon config path..."
    defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/.config/hammerspoon/init.lua" || return 1

    # VS Code key repeat
    echo "Configuring VS Code settings..."
    defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false || return 1

    # Finder settings
    echo "Configuring Finder settings..."
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true || return 1
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true || return 1

    # Dock settings
    echo "Configuring Dock settings..."
    defaults write com.apple.dock autohide-delay -float 0 || return 1
    killall Dock || return 1

    echo "MacOS defaults configured successfully!"
}

# Create hushlogin file
create_hushlogin() {
    echo "Creating .hushlogin file..."
    touch "$HOME/.hushlogin"
    [ $? -ne 0 ] && return 1
    echo "File .hushlogin created!"
}

# Main setup
main() {
    echo "Starting setup..."
    install_homebrew || { echo "Error: Homebrew installation failed!"; exit 1; }
    clone_repo || { echo "Error: Repository setup failed!"; exit 1; }
    install_brew_packages || echo "Error: Package installation from Brewfile failed!"
    create_symlinks || echo "Error: Failed to create symbolic links. Check for conflicts!"
    install_nodejs || echo "Error: Node.js installation failed!"
    install_jetbrains_mono || echo "Error: JetBrains Mono font installation failed!"
    macos_defaults_setup || echo "Error: macOS defaults setup failed!"
    create_hushlogin || echo "Error: Failed to create .hushlogin file!"
    echo "Setup complete! Your system is now configured."
}

main
