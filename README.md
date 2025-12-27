<samp>

# Dotfiles

This repository contains my personal configuration files for macOS. It uses Homebrew for package management and includes settings for various tools and applications.

## Structure

```
.
├── .config/                # Configuration files
│   ├── brew/               # Homebrew bundle file
│   ├── ghostty/            # Ghostty terminal settings
│   ├── git/                # Git configuration
│   ├── nvim/               # Neovim configuration
│   ├── rg/                 # Ripgrep configuration
│   └── zsh/                # Zsh configuration
├── .vscode/                # VS Code settings
├── .zshenv                 # Environment variables
├── README.md               # This file
└── install.sh              # Install script
```

## Quick Start

Install everything with a single command:

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/kopievskyd/dotfiles/refs/heads/main/install.sh)"
```

> [!NOTE]
> This download and execute a script. Inspect the [install.sh](install.sh) before running.

## XDG Compliance
These dotfiles follow the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/) to keep the home directory clean and organized. All configuration files are properly structured according to these standards.

## Package Management

[Homebrew](https://brew.sh/) is used as the primary package manager, with [Homebrew Bundle](https://docs.brew.sh/Brew-Bundle-and-Brewfile) for declarative management of packages, applications, and VS Code extensions.

A specific environment variable defined in `.zshenv` allows you to run `brew bundle` from anywhere, automatically using the correct Brewfile from your config directory:

```sh
export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/brew/Brewfile"
```

</samp>
