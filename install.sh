#!/bin/bash

set -u

readonly REPO_URL="https://github.com/kopievskyd/dotfiles.git"
readonly HOMEBREW_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
readonly FONT_API_URL="https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest"

readonly REPO_DIR="$HOME/Developer/.dotfiles"
readonly FONT_DIR="$HOME/Library/Fonts"
readonly HOMEBREW_PATH="/opt/homebrew/bin/brew"
readonly BREWFILE_PATH="$HOME/.config/brew/Brewfile"
readonly VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
readonly VSCODE_SETTINGS_SOURCE="$HOME/.vscode/settings.json"
readonly VSCODE_SETTINGS_TARGET="$VSCODE_USER_DIR/settings.json"

dotfiles() {
    git --git-dir="$REPO_DIR" --work-tree="$HOME" "$@"
}

setup_bare_repo() {
    if [[ ! -d "$REPO_DIR" ]]; then
        printf "Cloning into bare repository...\n"
        git clone --bare --quiet "$REPO_URL" "$REPO_DIR" || return 1
    else
        printf "Fetching updates for existing bare repository...\n"
        dotfiles pull --rebase --autostash --quiet || return 1
    fi

    printf "Checking out dotfiles...\n"
    dotfiles config core.sparseCheckout true
    dotfiles sparse-checkout init --no-cone
    dotfiles sparse-checkout set '/*' '!README.md' '!install.sh'
    dotfiles config status.showUntrackedFiles no
    dotfiles checkout || return 1
}

install_homebrew() {
    if ! command -v brew &>/dev/null; then
        printf "Installing Homebrew...\n"
        bash -c "$(curl -fsSL "$HOMEBREW_URL")"
        eval "$("$HOMEBREW_PATH" shellenv)"
    fi
}

install_brew_packages() {
	[[ -f "$BREWFILE_PATH" ]] || return 1
	export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
	printf "Installing packages from Brewfile...\n"
	brew bundle --file="$BREWFILE_PATH"
	brew cleanup --prune=all &>/dev/null
}

install_jetbrains_mono() {
	[[ -f "$FONT_DIR/JetBrainsMono-Regular.ttf" ]] && return 0

	printf "Installing JetBrains Mono...\n"
	local font_url temp_dir ttf_dir
	font_url=$(curl -fsSL "$FONT_API_URL" |
		grep -o '"browser_download_url": *"[^"]*\.zip"' |
		head -1 | cut -d'"' -f4)
	[[ -z "$font_url" ]] && return 1

	temp_dir=$(mktemp -d)
	trap "rm -rf '$temp_dir'" EXIT
	curl -fL -o "$temp_dir/JetBrainsMono.zip" "$font_url" &>/dev/null || return 1
	unzip -q "$temp_dir/JetBrainsMono.zip" -d "$temp_dir" || return 1
	ttf_dir=$(find "$temp_dir" -type d -iname "ttf" | head -n 1)
	[[ -z "$ttf_dir" ]] && return 1

	mkdir -p "$FONT_DIR"
	cp "$ttf_dir"/*.ttf "$FONT_DIR/" || return 1
}

install_sf_mono() {
    [[ -f "$FONT_DIR/SF-Mono-Regular.otf" ]] && return 0
    printf "Installing SF Mono...\n"
    cp -R /System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts/. ~/Library/Fonts || return 1
}

create_vscode_symlinks() {
    [[ -f "$VSCODE_SETTINGS_SOURCE" ]] || return 1
    mkdir -p "$VSCODE_USER_DIR"
    printf "Creating symlink for VS Code settings...\n"
    ln -sf "$VSCODE_SETTINGS_SOURCE" "$VSCODE_SETTINGS_TARGET" || return 1
}

macos_setup() {
    printf "Configuring macOS defaults...\n"
    sudo scutil --set HostName macbook
    sudo scutil --set LocalHostName macbook
    sudo scutil --set ComputerName macbook
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
    defaults write com.apple.dock autohide-delay -float 0
    dscacheutil -flushcache
    killall Dock || true
}

main() {
    install_homebrew
    setup_bare_repo || { printf "Error: Dotfiles setup failed.\n" >&2; exit 1; }
    install_brew_packages || printf "Warning: Brewfile installation failed.\n" >&2
    install_jetbrains_mono || printf "Warning: JetBrains Mono installation failed.\n" >&2
    install_sf_mono || printf "Warning: SF Mono installation failed.\n" >&2
    create_vscode_symlinks || printf "Warning: VS Code symlink creation failed.\n" >&2
    macos_setup
    printf "Setup complete!\n"
}

main
