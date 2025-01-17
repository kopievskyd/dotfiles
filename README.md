# Dot
This repository contains my personal dotfiles for configuring various tools and applications on my system.

## Requirements
Ensure you have the following tools installed on your system:

### Git
```
brew install git
```

### Stow
```
brew install stow
```

## Installation
Clone the repository:
```
git clone https://github.com/kpvskd/dot.git ~/Developer
```

Use GNU Stow to create symlinks for the dotfiles:
```
stow --no-folding -Rt ~ */
```

## Usage
After setting up the dotfiles, you may need to restart your terminal or reload configurations for the changes to take effect.

## License
This project is licensed under the MIT License — see the [LICENSE](https://github.com/kpvskd/dot/blob/main/LICENSE) file for details.
