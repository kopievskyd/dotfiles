# History
HISTSIZE=120000
SAVEHIST=100000
HISTFILE="${XDG_STATE_HOME}/.zsh_history"
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt HIST_VERIFY

# Variables
typeset -U path
path=("${HOMEBREW_PREFIX}/bin" $path)
path=("${GOPATH}/bin" $path)

# Keybindings
bindkey -v '^?' backward-delete-char
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# Aliases
alias wget="wget --hsts-file=${XDG_CACHE_HOME}/wget-hsts"
alias tree="tree -F -C --dirsfirst --noreport"
alias ls="ls -p --color"

# Completion
fpath+=("${HOMEBREW_PREFIX}/share/zsh/site-functions")
fpath+=("${ZDOTDIR}/completion")
autoload -Uz compinit && compinit -d "${XDG_CACHE_HOME}/.zcompdump"
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/.zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-flags \
    --no-info --no-separator --pointer='' --marker='  ' --color=fg:15,bg+:8

# Functions
source "${ZDOTDIR}/functions/git_status.zsh"
source "${ZDOTDIR}/functions/defer.zsh"
source "${ZDOTDIR}/functions/plug.zsh"

# Plugins
defer plug "zsh-users/zsh-syntax-highlighting"
defer plug "Aloxaf/fzf-tab"

# Prompt
setopt PROMPT_SUBST
PROMPT_DIR=$'%F{magenta}%~%f'
PROMPT_CHAR=$'%F{%(?.default.red)}%(!.#.$)%f'
PROMPT='${PROMPT_DIR}$(git_status) ${PROMPT_CHAR} '
