#!/bin/bash

readonly REPO_URL="https://github.com/kopievskyd/dotfiles.git"
readonly REPO_DIR="${HOME}/Developer/dotfiles"
readonly FONT_DIR="${HOME}/Library/Fonts"
readonly HOMEBREW_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
readonly BREWFILE_PATH="${HOME}/.config/homebrew/Brewfile"
readonly VSCODE_USER_DIR="${HOME}/Library/Application Support/Code/User"
readonly VSCODE_SETTINGS_SOURCE="${HOME}/.vscode/settings.json"
readonly VSCODE_SETTINGS_TARGET="${VSCODE_USER_DIR}/settings.json"
readonly HAMMERSPOON_CONFIG_PATH="${HOME}/.config/hammerspoon/init.lua"

_dotfiles() {
    git --git-dir="${REPO_DIR}" --work-tree="${HOME}" "$@"
}

setup_bare_repo() {
    if [[ ! -d "${REPO_DIR}" ]]; then
        git clone --bare "${REPO_URL}" "${REPO_DIR}" || return 1
    else
        _dotfiles fetch || return 1
    fi

    printf "Checking out dotfiles...\n"
    _dotfiles config core.sparseCheckout true
    _dotfiles sparse-checkout init --no-cone
    _dotfiles sparse-checkout set '/*' '!assets/' '!LICENSE' '!README.md' '!install.sh'
    _dotfiles config status.showUntrackedFiles no
    _dotfiles checkout || return 1
}

install_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        printf "Installing Homebrew...\n"
        /bin/bash -c "$(curl -fsSL "${HOMEBREW_URL}")"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

install_brew_packages() {
    if [[ -f "${BREWFILE_PATH}" ]]; then
        printf "Installing packages from Brewfile...\n"
        brew bundle --file="${BREWFILE_PATH}"
        brew cleanup --prune=all >/dev/null
    else
        return 1
    fi
}

install_jetbrains_mono() {
    printf "Installing JetBrains Mono font...\n"

    local api_url="https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest"
    local font_url
    font_url=$(curl -fsSL "$api_url" |
        grep -o '"browser_download_url": *"[^"]*\.zip"' |
        head -1 |
        cut -d'"' -f4)
    [[ -z "${font_url}" ]] && return 1

    local temp_dir
    temp_dir=$(mktemp -d)
    trap 'rm -rf "${temp_dir}"' RETURN

    curl -fL -o "${temp_dir}/JetBrainsMono.zip" "${font_url}" || return 1
    unzip -q "${temp_dir}/JetBrainsMono.zip" -d "${temp_dir}" || return 1

    local ttf_dir
    ttf_dir=$(find "${temp_dir}" -type d -iname "ttf" | head -n 1)
    [[ -z "${ttf_dir}" ]] && return 1

    mkdir -p "${FONT_DIR}"
    cp "$ttf_dir"/*.ttf "$FONT_DIR/" || return 1
}

create_vscode_symlinks() {
    if [[ -f "${VSCODE_SETTINGS_SOURCE}" ]]; then
        mkdir -p "${VSCODE_USER_DIR}"
        printf "Creating symlink for VS Code settings...\n"
        ln -sf "${VSCODE_SETTINGS_SOURCE}" "${VSCODE_SETTINGS_TARGET}" || return 1
    else
        return 1
    fi
}

create_hushlogin() {
    printf "Creating .hushlogin file...\n"
    touch "${HOME}/.hushlogin"
}

macos_defaults_setup() {
    printf "Configuring macOS defaults...\n"
    defaults write org.hammerspoon.Hammerspoon MJConfigFile "${HAMMERSPOON_CONFIG_PATH}"
    defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
    defaults write com.apple.dock autohide-delay -float 0
    killall Dock || true
}

main() {
    install_homebrew
    setup_bare_repo || { printf "Error: Dotfiles setup failed.\n" >&2; exit 1; }
    install_brew_packages || printf "Warning: Brewfile installation failed.\n" >&2
    install_jetbrains_mono || printf "Warning: JetBrains Mono installation failed.\n" >&2
    create_vscode_symlinks || printf "Warning: VS Code symlink creation failed.\n" >&2
    create_hushlogin
    macos_defaults_setup
    printf "Setup complete!\n"
}

main
