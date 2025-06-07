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
zstyle ':fzf-tab:*' fzf-flags \
  "--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8,\
fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC,\
marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8,\
selected-bg:#45475A,border:#313244,label:#CDD6F4"

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
