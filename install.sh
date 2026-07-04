#!/bin/bash

set -u

readonly HOSTNAME="air"

readonly REPO_DIR="$HOME/Developer/.dotfiles"
readonly HOMEBREW_PATH="/opt/homebrew/bin/brew"
readonly BREWFILE_PATH="$HOME/.config/brew/Brewfile"

readonly REPO_URL="https://github.com/kopievskyd/dotfiles.git"
readonly HOMEBREW_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

dotfiles() {
	git --git-dir="$REPO_DIR" --work-tree="$HOME" "$@"
}

setup_dotfiles() {
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
	if [[ ! -x "$HOMEBREW_PATH" ]]; then
		printf "Installing Homebrew...\n"
		bash -c "$(curl -fsSL "$HOMEBREW_URL")"
	fi

	eval "$("$HOMEBREW_PATH" shellenv)"
}

install_packages() {
	[[ -f "$BREWFILE_PATH" ]] || return 1

	export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"

	printf "Installing packages from Brewfile...\n"
	brew bundle --file="$BREWFILE_PATH"
	brew cleanup --prune=all &>/dev/null
}

create_user_dirs() {
	printf "Creating user directories...\n"

	mkdir -p \
		"${XDG_CACHE_HOME:-$HOME/.cache}" \
		"${XDG_DATA_HOME:-$HOME/.local/share}" \
		"${XDG_STATE_HOME:-$HOME/.local/state}"
}

create_hushlogin() {
	printf "Creating ~/.hushlogin...\n"
	touch "$HOME/.hushlogin"
}

cleanup_home() {
	printf "Cleaning up home directory...\n"

	rm -rf "$HOME/.zsh_sessions"
	rm -f "$HOME/.zsh_history"
	rm -f "$HOME/.CFUserTextEncoding"
}

setup_macos() {
	printf "Configuring macOS...\n"

	sudo scutil --set HostName "$HOSTNAME"
	sudo scutil --set LocalHostName "$HOSTNAME"
	sudo scutil --set ComputerName "$HOSTNAME"

	defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
	defaults write com.apple.dock autohide-delay -float 0
	dscacheutil -flushcache
	killall Dock || true
}

main() {
	install_homebrew
	setup_dotfiles || {
		printf "Error: Dotfiles setup failed.\n" >&2
		exit 1
	}
	create_user_dirs
	install_packages || printf "Warning: Brewfile installation failed.\n" >&2
	create_hushlogin
	cleanup_home
	setup_macos
	printf "Setup complete!\n"
}

main
