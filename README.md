<samp>

# Dotfiles

This repository contains my personal dotfiles and system configuration for macOS. This setup uses [GNU Stow](https://www.gnu.org/software/stow/) for symlink management, [Homebrew](https://brew.sh/) for package management, and includes configurations for various tools and applications.

## Directory Structure

```
.
├── ghostty/                # Ghostty terminal configuration
├── git/                    # Git configuration
├── hammerspoon/            # Hammerspoon scripts and configuration
├── homebrew/               # Homebrew bundle file
├── nvim/                   # Neovim configuration
├── vscode/                 # VS Code settings
├── zsh/                    # Zsh configuration
├── .stowrc                 # GNU Stow configuration
├── LICENSE                 # License file
├── README.md               # This file
└── setup.sh                # Setup script
```

## Quick Start

Install everything with a single command:

```sh
sh -c "$(curl -sSL https://raw.githubusercontent.com/kopievskyd/dotfiles/refs/heads/main/setup.sh)"
```

## Installation Details

The setup script performs the following actions:

1. Installs [Homebrew](https://brew.sh/) if not already installed
2. Clones this dotfiles repository
3. Installs all packages from the [Brewfile](https://github.com/kopievskyd/dotfiles/blob/main/homebrew/.config/homebrew/Brewfile)
4. Creates symbolic links with [GNU Stow](https://www.gnu.org/software/stow/)
5. Sets up [Node.js](https://nodejs.org/en) environment with [fnm](https://github.com/Schniz/fnm)
6. Installs [JetBrains Mono](https://github.com/JetBrains/JetBrainsMono) font
7. Configures macOS defaults:
    - Sets [Hammerspoon](https://www.hammerspoon.org/) config location
    - Configures [VS Code](https://code.visualstudio.com/) key repeat
    - Configures Finder settings
    - Sets Dock settings
8. Creates a `.hushlogin` file to disable login messages

## Manual Installation

To install manually instead of using the automated script, use the following method.

### Requirements

- [**Git**](https://git-scm.com/downloads): For cloning the repository
- [**GNU Stow**](https://www.gnu.org/software/stow/): For managing symlinks

> [!NOTE]
> - The [`.stowrc`](https://github.com/kopievskyd/dotfiles/blob/main/.stowrc) file in this repository configures the target directory and other stow options.
> - If you're selectively installing components, make sure to check for dependencies between configurations.

### Installation Steps

1. Clone this repository:
    
    ```sh
    git clone https://github.com/kopievskyd/dotfiles.git ~/.dotfiles
    ```
    
2. Navigate to the repository directory:
    
    ```sh
    cd ~/.dotfiles
    ```
    
3. Use GNU Stow to create symbolic links:
    
    ```sh
    # Symlink everything (the `/` ignores the README and other non-configuration files)
    stow */
    
    # Or selectively install specific configurations
    stow nvim       # Just the Neovim configuration
    ```

## XDG Base Directory Specification
This dotfiles repository follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/) to keep the home directory clean and organized. All configuration files are properly structured according to these standards.

### Benefits

- **Clean Home Directory**: Keeps dot files and directories organized
- **Centralized Configuration**: All configs in `~/.config`
- **Separate Data Storage**: Application data in `~/.local/share`
- **Cached Content**: Temporary files in `~/.local/cache`
- **State Information**: Application state in `~/.local/state`

## Homebrew Package Management

This dotfiles setup uses [Homebrew](https://brew.sh/) as the primary package manager for macOS, with [Homebrew Bundle](https://docs.brew.sh/Brew-Bundle-and-Brewfile) for declarative management of packages, applications, and VS Code extensions.

### Brewfile Structure

- **Formulae**: CLI Tools
- **Casks**: Applications
- **VS Code Extensions**

### Environment Configuration

The dotfiles include Homebrew-specific environment variable in `.zshenv`:

```sh
export HOMEBREW_BUNDLE_FILE="$HOME/.config/homebrew/Brewfile"
```

This configuration allows you to run `brew bundle` from any directory, and it will automatically use the correct Brewfile from your XDG-compliant configuration.

## Essential Applications and Tools

[`fnm`](https://github.com/Schniz/fnm) - fast node manager  
[`ghostty`](https://github.com/ghostty-org/ghostty) - terminal emulator  
[`git`](https://git-scm.com/downloads) - version control  
[`hammerspoon`](https://www.hammerspoon.org/) - automation tool  
[`homebrew`](https://brew.sh/) - package manager  
[`neovim`](https://github.com/neovim/neovim) - text editor  
[`rectangle`](https://github.com/rxhanson/Rectangle) - window manager  
[`stow`](https://www.gnu.org/software/stow/) - symlink farm manager  
[`syncthing`](https://github.com/syncthing/syncthing) - file synchronization  
[`vscode`](https://code.visualstudio.com/) - code editor  
[`zsh`](https://www.zsh.org/) - shell

A complete list of programs and tools can be found in the [Brewfile](https://github.com/kopievskyd/dotfiles/blob/main/homebrew/.config/homebrew/Brewfile).

## Zsh Configuration

Zsh setup is optimized for speed, usability, and minimal dependencies.

### Structure

```
zsh/
├── .config/
│   └── zsh/
│       ├── completion/       # Custom completion scripts
│       ├── .p10k.zsh         # Powerlevel10k configuration
│       └── .zshrc            # Main Zsh configuration
└── .zshenv                   # Environment variables
```

### Features

- **Fast Startup**: Using instant prompt from [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- **Minimal Zsh Plugin Manager**: [Zap Plugin Manager](https://github.com/zap-zsh/zap)
- **Custom Completions**: For commonly used tools
- **Enhanced History**: Configured for efficient search and deduplication

### Plugins

[`fzf-tab`](https://github.com/Aloxaf/fzf-tab) - fuzzy completion using fzf  
[`powerlevel10k`](https://github.com/romkatv/powerlevel10k) - fast and customizable prompt  
[`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions) - fish-like autosuggestions  
[`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting) - fish shell like syntax highlighting

## Neovim Configuration

Neovim setup is minimal and focused on using built-in features where possible, with carefully selected plugins for essential functionality.

### Structure

```
nvim/
├── lua/
│   ├── autocmds.lua     # Automatic commands
│   ├── keymaps.lua      # Key mappings
│   ├── options.lua      # Editor options
│   ├── plugins.lua      # Plugin definitions
│   └── utils.lua        # Utility functions
├── init.lua             # Main configuration file
└── lazy-lock.json       # Plugin lock file
```

### Features

- **Minimalist Philosophy**: Uses built-in features where possible
- **Default Color Scheme**: Uses built-in themes with transparent background
- **File Explorer**: Uses built-in Netrw instead of tree plugins
- **Fuzzy Finding**: Uses [mini.pick](https://github.com/echasnovski/mini.pick) for file search, live grep, and more
- **Persistent Undo History**: Keeps undo history across sessions
- **Custom Winbar**: Shows file information and git status
- **Custom Diagnostic Highlights**: Improved visibility of diagnostics
- **Lazy-loaded Plugins**: Only loads plugins when needed, using [lazy.nvim](https://github.com/folke/lazy.nvim)

### Key Mappings

Leader key set to `,` with intuitive mappings:

|Mapping|Description|
|---|---|
|`j` / `k`|Smart movement with line wrapping|
|`<leader>h`|Clear search highlights|
|`<leader>bn`|Switch to next buffer|
|`<leader>bp`|Switch to previous buffer|
|`<leader>bd`|Delete current buffer|
|`<leader>bf`|Format current buffer|
|`<leader>e`|Toggle Netrw file explorer|
|`<leader>ff`|Find files|
|`<leader>fg`|Live grep search|
|`<leader>fb`|Browse open buffers|

### Plugins

[`mason.nvim`](https://github.com/williamboman/mason.nvim) - manage LSP servers, DAP servers, linters, and formatters  
[`blink.cmp`](https://github.com/Saghen/blink.cmp) - completion plugin  
[`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig) - LSP configuration  
[`conform.nvim`](https://github.com/stevearc/conform.nvim) - lightweight powerful formatter  
[`nvim-surround`](https://github.com/kylechui/nvim-surround) - surround actions  
[`mini.pairs`](https://github.com/echasnovski/mini.pairs) - automatically manage character pairs  
[`mini.pick`](https://github.com/echasnovski/mini.pick) - fuzzy finder for files, text and anything else

## VS Code Configuration

VS Code setup is designed to provide a clean, distraction-free environment with a focus on essential features.

### Features
- **Minimalist Philosophy**: Focuses on reducing distractions and keeping the workspace clean
- **Default Theme**: Uses default theme in VS Code, maintaining a simple and clean look
- **Font**: Uses [JetBrains Mono](https://github.com/JetBrains/JetBrainsMono) for a consistent and legible code editing experience
- **Editor Tweaks**: Disables unnecessary features to maintain a clean interface
- **Brewfile for Extensions Installation**: Extensions are installed via a [Brewfile](https://docs.brew.sh/Brew-Bundle-and-Brewfile), allowing for an easy and consistent setup across different systems
- **Vim Integration**: Vim plugin to support Vim's editing modes directly within VS Code

### Plugins
[`material-icon-theme`](https://marketplace.visualstudio.com/items?itemName=pkief.material-icon-theme) - custom icons for files and folders  
[`errorlens`](https://marketplace.visualstudio.com/items?itemName=usernamehw.errorlens) - highlights errors and warnings in the editor  
[`vim`](https://marketplace.visualstudio.com/items?itemName=vscodevim.vim) - support Vim's editing modes  
[`prettier`](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) - code formatting with Prettier  
[`go`](https://marketplace.visualstudio.com/items?itemName=golang.go) - support for Go programming language

## Ghostty Terminal Configuration

The configuration is minimal, with settings carefully chosen to provide an optimal terminal experience.

### Features

- **Automatic Theme Switching**: Uses the [Zenwritten](https://github.com/zenbones-theme/zenbones.nvim) themes that adapt based on system appearance (light/dark mode)
- **Typography**: [JetBrains Mono](https://github.com/JetBrains/JetBrainsMono) font with optimized readability settings
- **Window Management**: Better padding and maximized windows by default

## Hammerspoon Configuration

Hammerspoon setup is designed to provide keyboard shortcuts for improved productivity.

### Features
- **Custom Key Bindings**: Use Ctrl + hjkl as arrow keys to navigate quickly

## License

Creative Commons Zero v1.0 Universal. See the [LICENSE](https://github.com/kopievskyd/dotfiles/blob/main/LICENSE) file for details.

</samp>
