# Enable instant prompt
if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Install plugin manager
if [ ! -d "$XDG_DATA_HOME/zap" ]; then
    zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --keep --branch release-v1
fi

# Enable plugin manager
[ -f "$XDG_DATA_HOME/zap/zap.zsh" ] && source "$XDG_DATA_HOME/zap/zap.zsh"

# Plugins
plug "romkatv/powerlevel10k"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-autosuggestions"
plug "Aloxaf/fzf-tab"

# Completion
fpath+="$ZDOTDIR/completion/"
autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/.zcompdump"
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/.zcompcache"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no

# History
HISTFILE="$XDG_STATE_HOME/.zsh_history"
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
alias ls='ls -lAh --color'
alias mkdir='mkdir -p'
alias vim='nvim'
alias tree='tree -C -a'
alias stow='stow --no-folding -Rt ~'

# Homebrew
if [[ -f "/opt/homebrew/bin/brew" ]] then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export HOMEBREW_NO_ANALYTICS=1
fi

# Powerlevel10k
[[ ! -f "$ZDOTDIR/.p10k.zsh" ]] || source "$ZDOTDIR/.p10k.zsh"

# Fast Node Manager
eval "$(fnm env --use-on-cd --shell zsh)"
