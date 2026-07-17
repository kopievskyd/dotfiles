#!/bin/bash
set -uo pipefail

readonly COMPUTERNAME='Air'
readonly HOSTNAME='air'

readonly DOTFILES_DIR="$HOME/.dotfiles"
readonly DOTFILES_URL='https://github.com/kopievskyd/dotfiles'

# Path to the Brewfile with packages to install
readonly BREWFILE="$HOME/.config/homebrew/Brewfile"

# Languages for tree-sitter parser installation
readonly TS_LANGUAGES=(java)

readonly YELLOW='\033[33m'
readonly GREEN='\033[32m'
readonly RED='\033[31m'
readonly RESET='\033[0m'

function info() {
	printf 'info: %s\n' "$1"
}

function warn() {
	printf "${YELLOW}warn:${RESET} %s\n" "$1" >&2
}

function error() {
	printf "${RED}error:${RESET} %s\n" "$1" >&2
}

function success() {
	printf "${GREEN}✓${RESET} %s\n" "$1"
}

function request_sudo() {
	SUDO_PROMPT='sudo: enter password ' sudo -v
}

function setup_sudo() {
	local sudoers='/private/etc/sudoers.d/prompt'

	if [[ -f "$sudoers" ]]; then
		warn 'sudo configuration already exists'
		warn 'skipping sudo configuration'
		return 0
	fi

	# Create a temporary sudoers file for validation
	local tmp
	tmp=$(mktemp)
	printf '%s\n' \
		'Defaults passprompt="sudo: enter password "' \
		'Defaults passprompt_override' \
		'Defaults badpass_message="sudo: sorry, try again"' >"$tmp"

	# Expand $tmp now so the trap removes the temporary file
	# automatically when the function returns
	# shellcheck disable=SC2064
	trap "rm -f '$tmp'" RETURN

	info 'configuring sudo prompt'
	visudo -cf "$tmp" >/dev/null || {
		warn 'invalid sudo configuration'
		return 1
	}
	sudo install -m 0440 "$tmp" "$sudoers" || {
		warn 'failed to configure sudo prompt'
		return 1
	}
}

function install_homebrew() {
	local homebrew='/opt/homebrew/bin/brew'
	local homebrew_url='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'

	if [[ ! -x "$homebrew" ]]; then
		info 'installing homebrew'
		NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL "$homebrew_url")" &>/dev/null || {
			error 'failed to install homebrew'
			return 1
		}
	fi

	eval "$("$homebrew" shellenv)" || {
		error 'failed to load homebrew environment'
		return 1
	}

	success 'homebrew installed'
}

function dotfiles() {
	git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

function setup_dotfiles() {
	if [[ ! -d "$DOTFILES_DIR" ]]; then
		info 'cloning dotfiles repository'
		git clone --bare --quiet "$DOTFILES_URL" "$DOTFILES_DIR" || {
			error 'failed to clone dotfiles repository'
			return 1
		}

		# Don't list every file in $HOME as untracked
		dotfiles config status.showUntrackedFiles no

		# Check out everything except bootstrap.sh and README.md
		dotfiles config core.sparseCheckout true
		dotfiles sparse-checkout init --no-cone
		dotfiles sparse-checkout set '/*' '!bootstrap.sh' '!README.md'
	else
		info 'updating dotfiles repository'
		dotfiles pull --rebase --autostash --quiet || {
			warn 'failed to update dotfiles repository'
		}
	fi

	info 'checking out dotfiles'
	dotfiles checkout --quiet || {
		error 'failed to check out dotfiles'
		return 1
	}

	success 'dotfiles installed'
}

function ensure_directories() {
	info 'creating required directories'
	mkdir -p \
		"$HOME/.cache" \
		"$HOME/.local/share" \
		"$HOME/.local/state"
}

function install_packages() {
	if [[ ! -f "$BREWFILE" ]]; then
		warn "brewfile not found: $BREWFILE"
		return 1
	fi

	# Use the custom GOPATH for Go packages installed via Brewfile
	export GOPATH="$HOME/.local/share/go"

	info 'installing packages'
	brew bundle --file="$BREWFILE" &>/dev/null || {
		warn 'some packages may not have been installed'
		return 1
	}

	success 'packages installed'
}

function install_parser() {
	local lang="$1"
	local parser_dir="$2"
	local queries_dir="$3"
	local repo="tree-sitter-$lang"
	local ts_url="https://github.com/tree-sitter/$repo"
	local src_dir="$HOME/.local/share/tree-sitter/$repo"

	if [[ ! -d "$src_dir" ]]; then
		git clone --depth=1 --quiet "$ts_url" "$src_dir" || {
			warn "failed to clone $repo"
			return 1
		}
	else
		git -C "$src_dir" pull --ff-only --quiet || {
			warn "failed to update $repo"
		}
	fi

	# Building parser
	tree-sitter build -o "$parser_dir/$lang.so" "$src_dir" || {
		warn "failed to build $lang parser"
		return 1
	}

	# Installing queries
	if [[ -d "$src_dir/queries" ]]; then
		rm -rf "${queries_dir:?}/${lang:?}"
		cp -R "$src_dir/queries" "$queries_dir/$lang" || {
			warn "failed to install $lang queries"
			return 1
		}
	fi

	info "$repo parser installed"
}

function install_ts_parsers() {
	local parser_dir="$HOME/.local/share/nvim/site/parser"
	local queries_dir="$HOME/.local/share/nvim/site/queries"
	local total="${#TS_LANGUAGES[@]}"
	local installed="$total"

	command -v tree-sitter &>/dev/null || {
		warn 'tree-sitter-cli not found'
		warn 'skipping tree-sitter parser installation'
		return 1
	}

	mkdir -p "$parser_dir" "$queries_dir" || {
		warn 'failed to create parser directories'
		warn 'skipping tree-sitter parser installation'
		return 1
	}

	local lang
	for lang in "${TS_LANGUAGES[@]}"; do
		install_parser "$lang" "$parser_dir" "$queries_dir" || {
			warn "skipping $lang parser installation"
			((--installed))
		}
	done

	if ((installed == total)); then
		success 'tree-sitter parsers installed'
	else
		warn "installed $installed of $total tree-sitter parsers"
	fi
}

# Increments the caller's 'failed' counter via Bash dynamic scoping,
# and returns the original command's exit status
function apply() {
	"$@"
	local status=$?
	((status == 0)) || ((++failed))
	return "$status"
}

function apply_settings() {
	local failed=0

	# Setting hostname
	apply sudo scutil --set ComputerName "$COMPUTERNAME"
	apply sudo scutil --set HostName "$HOSTNAME"
	apply sudo scutil --set LocalHostName "$HOSTNAME"

	# Setting TextEdit
	apply defaults write com.apple.TextEdit RichText -bool false
	apply defaults write com.apple.TextEdit NSFixedPitchFontSize -int 14
	apply defaults write com.apple.TextEdit CheckSpellingWhileTyping -bool false
	apply defaults write com.apple.TextEdit CorrectSpellingAutomatically -bool false
	apply defaults write com.apple.TextEdit ShowRuler -bool false
	apply defaults write com.apple.TextEdit SmartSubstitutionsEnabledInRichTextOnly -bool false
	apply defaults write com.apple.TextEdit SmartCopyPaste -bool false
	apply defaults write com.apple.TextEdit SmartQuotes -bool false
	apply defaults write com.apple.TextEdit SmartDashes -bool false
	apply defaults write com.apple.TextEdit TextReplacement -bool false

	# Refresh Activity Monitor every 2 seconds
	apply defaults write com.apple.ActivityMonitor "UpdatePeriod" -int "2"

	# Enable key repeat
	apply defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

	# Prevent creating .DS_Store files on network and USB volumes
	apply defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	apply defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

	# Remove dock auto-hide delay
	apply defaults write com.apple.dock autohide-delay -float 0 && killall Dock

	# Suppressing login message
	touch "$HOME/.hushlogin"

	if ((failed == 0)); then
		success 'system settings applied'
	else
		warn 'some system settings were not applied'
	fi
}

function cleanup() {
	info 'cleaning up'

	rm -rf \
		"$HOME/Library/Caches"/* \
		"$HOME/.cache"/* \
		2>/dev/null

	rm -rf \
		"$HOME/.CFUserTextEncoding" \
		"$HOME/.zsh_sessions" \
		"$HOME/.zsh_history"
}

function main() {
	# Request sudo access for proper Homebrew installation
	request_sudo || exit 1

	setup_sudo
	install_homebrew || exit 1
	setup_dotfiles || exit 1
	ensure_directories
	install_packages
	install_ts_parsers
	apply_settings
	cleanup

	success 'setup complete'
}

main
