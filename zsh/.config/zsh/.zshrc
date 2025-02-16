# Enable instant prompt
if [[ -r "$HOME/.local/cache/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "$HOME/.local/cache/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Install plugin manager
if [ ! -d "$HOME/.local/share/zap" ]; then
    zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --keep --branch release-v1
fi

# Enable plugin manager
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"

# Plugins
plug "romkatv/powerlevel10k"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-autosuggestions"
plug "Aloxaf/fzf-tab"

# Completion
fpath+="$HOME/.config/zsh/completion/"
autoload -Uz compinit && compinit -d "$HOME/.local/cache/.zcompdump"
zstyle ':completion:*' cache-path "$HOME/.local/cache/.zcompcache"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no

# History
HISTFILE="$HOME/.local/state/.zsh_history"
HISTSIZE=3000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt hist_verify
setopt inc_append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_expire_dups_first
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Aliases
alias ls='ls -lAh --color | grep "^d" | grep -v "^total" && ls -lAh --color | grep -v "^d" | grep -v "^total"'
alias tree='tree -C --dirsfirst --noreport'
alias mkdir='mkdir -p'
alias stow='stow --restow --no-folding'

# Powerlevel10k
[[ ! -f "$HOME/.config/zsh/.p10k.zsh" ]] || source "$HOME/.config/zsh/.p10k.zsh"

# Homebrew
if [[ -f "/opt/homebrew/bin/brew" ]] then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Fast Node Manager
eval "$(fnm env --use-on-cd --shell zsh)"
