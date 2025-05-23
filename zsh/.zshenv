# XDG Base Directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.local/cache"

# Application-specific paths
export ZDOTDIR="$HOME/.config/zsh"
export LESSHISTFILE="$HOME/.local/state/less/history"
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"
export NPM_CONFIG_CACHE="$HOME/.local/cache/npm"
export GOPATH="$HOME/.local/share/go"
export PATH="$PATH:$GOPATH/bin"

# Homebrew configuration
export HOMEBREW_BUNDLE_FILE="$HOME/.config/homebrew/Brewfile"
export HOMEBREW_NO_ANALYTICS=1

# Default editors
export VISUAL=nvim
export EDITOR=nvim
