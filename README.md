<samp>

# Dotfiles

This repository contains my personal configuration files for macOS. It uses Homebrew for package management and includes settings for various tools and applications.

## Structure

```
.
├── .config/                # Configuration files
│   ├── ghostty/            # Ghostty terminal settings
│   ├── git/                # Git configuration
│   ├── homebrew/           # Homebrew bundle file
│   ├── nvim/               # Neovim configuration
│   ├── rg/                 # Ripgrep configuration
│   └── zsh/                # Zsh configuration
├── .gnupg/                 # GPG configuration
├── .ssh/                   # SSH configuration
├── .zshenv                 # Environment variables
├── bootstrap.sh            # Bootstrap script
└── README.md               # This file
```

## Quick Start

Bootstrap a new macOS installation:

```sh
curl -fsSL https://raw.githubusercontent.com/kopievskyd/dotfiles/main/bootstrap.sh | bash
```

</samp>
