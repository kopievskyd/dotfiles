# Set XDG Base Directory Specification paths
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_CACHE_HOME="${HOME}/.local/cache"

# Application-specific paths
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export GOPATH="${XDG_DATA_HOME}/go"
export LESSHISTFILE="${XDG_STATE_HOME}/less/history"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm"

# Homebrew configuration
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
    export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}"
    export HOMEBREW_BUNDLE_FILE="${XDG_CONFIG_HOME}/homebrew/Brewfile"
    export HOMEBREW_NO_ANALYTICS=1
    export PATH="${HOMEBREW_PREFIX}/bin:${PATH}"
fi

# Add Go binaries to PATH
export PATH="${GOPATH}/bin:${PATH}"

# Default editors
export VISUAL="nvim"
export EDITOR="${VISUAL}"
