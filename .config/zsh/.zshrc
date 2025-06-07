# Enable instant prompt
if [[ -r "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Install plugin manager
if [[ ! -d "${XDG_DATA_HOME}/zap" ]]; then
    zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) \
        --keep --branch release-v1
fi

# Enable plugin manager
if [[ -r "${XDG_DATA_HOME}/zap/zap.zsh" ]]; then
    source "${XDG_DATA_HOME}/zap/zap.zsh"
fi

# Plugins
plug "romkatv/powerlevel10k"
plug "romkatv/zsh-defer"
zsh-defer plug "zsh-users/zsh-syntax-highlighting"
zsh-defer plug "zsh-users/zsh-autosuggestions"
zsh-defer plug "Aloxaf/fzf-tab"

# Completion
fpath+=("${HOMEBREW_PREFIX}/share/zsh/site-functions")
fpath+=("${ZDOTDIR}/completion")
autoload -Uz compinit && compinit -d "${XDG_CACHE_HOME}/.zcompdump"
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/.zcompcache"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-flags "--color=\
    bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796,\
    fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6,\
    marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796,\
    selected-bg:#494D64,border:#363A4F,label:#CAD3F5"

# History
HISTFILE="${XDG_STATE_HOME}/.zsh_history"
HISTSIZE=5000
SAVEHIST="${HISTSIZE}"
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_VERIFY

# Keybindings
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey -v '^?' backward-delete-char

# Aliases
alias dotfiles="git --git-dir=${HOME}/Developer/dotfiles --work-tree=${HOME}"
alias tree="tree -C --dirsfirst --noreport"
alias ls="ls -lAh --color"
alias mkdir="mkdir -p"

# Add Homebrew binaries to PATH
export PATH="${HOMEBREW_PREFIX}/bin:${PATH}"

# Add Go binaries to PATH
export PATH="${GOPATH}/bin:${PATH}"

# Prompt Powerlevel10k
if [[ -r "${ZDOTDIR}/.p10k.zsh" ]]; then
    source "${ZDOTDIR}/.p10k.zsh"
fi

# Set TTY for GPG
if [[ -t 1 ]]; then
    export GPG_TTY="$(tty)"
fi
