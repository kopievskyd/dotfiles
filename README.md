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
├── .gnupg/                 # GPG configuration
├── .ssh/                   # SSH configuration
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

</samp>
