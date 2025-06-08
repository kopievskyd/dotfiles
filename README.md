<samp>

# Dotfiles

This repository contains my personal configuration files for macOS. It uses Homebrew for package management and includes settings for various tools and applications.

## Preview

![Screenshot](assets/screenshot.png)

## Structure

```
.
├── .config/                # Configuration files
│   ├── ghostty/            # Ghostty terminal settings
│   ├── git/                # Git configuration
│   ├── hammerspoon/        # Hammerspoon scripts
│   ├── homebrew/           # Homebrew bundle file
│   ├── nvim/               # Neovim configuration
│   ├── ripgrep/            # Ripgrep configuration
│   └── zsh/                # Zsh configuration
├── .vscode/                # VS Code settings
├── assets/                 # Screenshots and images
├── .zshenv                 # Environment variables
├── LICENSE                 # License file
├── README.md               # This file
└── install.sh              # Install script
```

## Quick Start

Install everything with a single command:

```sh
curl -fsSL https://raw.githubusercontent.com/kopievskyd/dotfiles/refs/heads/main/install.sh | sh
```

## Package Management

[Homebrew](https://brew.sh/) is used as the primary package manager, with [Homebrew Bundle](https://docs.brew.sh/Brew-Bundle-and-Brewfile) for declarative management of packages, applications, and VS Code extensions.

A specific environment variable defined in `.zshenv` allows you to run `brew bundle` from anywhere, automatically using the correct Brewfile from your config directory:

```sh
export HOMEBREW_BUNDLE_FILE="$HOME/.config/homebrew/Brewfile"
```

## Zsh Configuration

```
.
├── .config/
│   └── zsh/
│       ├── completion/       # Custom completion scripts
│       ├── .p10k.zsh         # Powerlevel10k configuration
│       └── .zshrc            # Main Zsh configuration
└── .zshenv                   # Environment variables
```

### Features

- **Fast Startup**: Uses instant prompt from [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- **Plugin Manager**: [Zap Plugin Manager](https://github.com/zap-zsh/zap)
- **Custom Completions**: For commonly used tools
- **Enhanced History**: Configured for efficient search and deduplication

### Plugins

- [`powerlevel10k`](https://github.com/romkatv/powerlevel10k) - fast and customizable prompt
- [`zsh-defer`](https://github.com/romkatv/zsh-defer) - deferred execution of Zsh commands
- [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting) - fish-like syntax highlighting
- [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions) - fish-like autosuggestions
- [`fzf-tab`](https://github.com/Aloxaf/fzf-tab) - fuzzy completion using fzf

## Neovim Configuration

```
nvim/
├── lua/
│   ├── autocmds.lua     # Autocommands
│   ├── keymaps.lua      # Key mappings
│   ├── lsp.lua          # LSP configuration
│   ├── options.lua      # Editor options
│   ├── plugins.lua      # Plugin definitions
│   └── utils.lua        # Utility functions
├── init.lua             # Main configuration file
└── lazy-lock.json       # Plugin lock file (generated)
```

### Features

- **Minimalist Philosophy**: Uses built-in features where possible
- **Lazy-loaded Plugins**: Only loads plugins when needed, using [lazy.nvim](https://github.com/folke/lazy.nvim)
- **Fuzzy Finding**: Uses [mini.pick](https://github.com/echasnovski/mini.pick) for file search, live grep, and more
- **Persistent Undo History**: Keeps undo history across sessions
- **File Explorer**: Uses built-in Netrw instead of tree plugins
- **Custom Winbar**: Shows file path and modification status
- **Color Scheme**: [Catppuccin](https://github.com/catppuccin/nvim)

### Plugins

- [`catppuccin`](https://github.com/catppuccin/nvim) - color scheme
- [`mason.nvim`](https://github.com/mason-org/mason.nvim) - manages LSP servers, DAP adapters, linters, and formatters
- [`blink.cmp`](https://github.com/Saghen/blink.cmp) - completion plugin
- [`conform.nvim`](https://github.com/stevearc/conform.nvim) - lightweight yet powerful formatter
- [`nvim-surround`](https://github.com/kylechui/nvim-surround) - surround actions
- [`mini.pairs`](https://github.com/echasnovski/mini.pairs) - automatically manages character pairs
- [`mini.pick`](https://github.com/echasnovski/mini.pick) - fuzzy finder for files, text, and anything else

### Key Mappings

Leader key is set to `,` with the following mappings:

|Mapping|Description|
|---|---|
|`j` / `k`|Smart movement with line wrapping|
|`<leader>h`|Clear search highlights|
|`<leader>bn`|Switch to next buffer|
|`<leader>bp`|Switch to previous buffer|
|`<leader>bd`|Delete current buffer|
|`<leader>bf`|Format current buffer|
|`<leader>e`|Toggle file explorer|
|`<leader>ff`|Find files|
|`<leader>fg`|Live grep search|
|`<leader>fb`|Browse open buffers|

## License

Creative Commons Zero v1.0 Universal. See the [LICENSE](https://github.com/kopievskyd/dotfiles/blob/main/LICENSE) file for details.

</samp>
