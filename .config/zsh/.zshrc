# Load functions
for file in "$ZDOTDIR/functions/"*.zsh(N); do
    source "$file"
done

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
export VISUAL='nvim'
export EDITOR="$VISUAL"

# Add to path
typeset -U path
path=("$HOMEBREW_PREFIX/sbin" $path)
path=("$HOMEBREW_PREFIX/bin" $path)
path=("$GOPATH/bin" $path)

# Keybindings
bindkey -v '^?' backward-delete-char
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# Enable vim-surround
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround

# Enable vim-style text objects
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed

for km in viopp visual; do
    bindkey -M "$km" -- '-' vi-up-line-or-history

    for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
        bindkey -M "$km" "$c" select-quoted
    done

    for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
        bindkey -M "$km" "$c" select-bracketed
    done
done

# Aliases
alias ls='ls -F'
alias tree='tree -F --dirsfirst --noreport'
alias wget='wget --no-hsts'

# Enable plugins
defer plug 'zsh-users/zsh-syntax-highlighting'
defer plug 'zsh-users/zsh-completions'
defer plug 'Aloxaf/fzf-tab'

# Completion setup
fpath+=("$HOMEBREW_PREFIX/share/zsh/site-functions")
autoload -Uz compinit && defer compinit -i -d "$XDG_CACHE_HOME/.zcompdump"
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/.zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-flags \
    --no-info --no-separator --pointer='' --marker='  ' --color=fg:7,bg+:8

# Enable prompt substitution
setopt PROMPT_SUBST

# Set prompt
PS1='%F{8}%m %F{magenta}%1~%F{white}${GIT_STATUS} %(?..%F{red})➜%f '
