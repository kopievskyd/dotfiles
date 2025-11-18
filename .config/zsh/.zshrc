# Load functions
source "$ZDOTDIR/functions/git_status.zsh"
source "$ZDOTDIR/functions/defer.zsh"
source "$ZDOTDIR/functions/plug.zsh"

# History settings
HISTSIZE=120000
SAVEHIST=100000
HISTFILE="$XDG_STATE_HOME/.zsh_history"
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt HIST_VERIFY

# Export variables
export VISUAL="nvim"
export EDITOR="$VISUAL"

# Add to path
typeset -U path
path=("$HOMEBREW_PREFIX/bin" $path)
path=("$GOPATH/bin" $path)

# Keybindings
bindkey -v '^?' backward-delete-char
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# Aliases
alias ls="ls -F"
alias tree="tree -F --dirsfirst --noreport"
alias wget="wget --no-hsts"
alias dotfiles="git --git-dir=$HOME/Developer/.dotfiles --work-tree=$HOME"

# Completion setup
fpath+=("$ZDOTDIR/completion")
fpath+=("$HOMEBREW_PREFIX/share/zsh/site-functions")
autoload -Uz compinit && defer compinit -d "$XDG_CACHE_HOME/.zcompdump"
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/.zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-flags \
    --no-info --no-separator --pointer='' --marker='  ' --color=fg:7,bg+:8

# Enable plugins
defer plug "zsh-users/zsh-syntax-highlighting"
defer plug "Aloxaf/fzf-tab"

# Enable prompt substitution
setopt PROMPT_SUBST

# Set prompt
PS1=' %(?..%F{red})➜ %F{blue}%~%F{white}$(git_status)%f '
