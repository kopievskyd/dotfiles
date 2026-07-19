# Async git status for zsh prompt that shows
# branch name and dirty state without blocking prompt
zmodload zsh/system
autoload -Uz is-at-least

# Cached git status
typeset -g GIT_STATUS

# Async state variables
typeset -g _GIT_ASYNC_FD _GIT_ASYNC_PID

# Get git status
function _get_git_status() {
    emulate -L zsh
    local git_dir branch dirty head_content

    git_dir=$(git rev-parse --git-dir 2>/dev/null) || return
    [[ -f "$git_dir/HEAD" ]] || return
    IFS= read -r head_content < "$git_dir/HEAD"
    if [[ "$head_content" =~ '^ref: refs/heads/(.*)$' ]]; then
        branch="${match[1]}"
    elif [[ "$head_content" =~ '^([0-9a-f]{8})[0-9a-f]+$' ]]; then
        branch="${match[1]}"
    else
        return
    fi

    git update-index --refresh &>/dev/null
    if git rev-parse --verify HEAD &>/dev/null; then
        git diff-index --quiet HEAD 2>/dev/null || dirty='*'
    else
        dirty='*'
    fi
    print -rn -- " $branch$dirty"
}

# Async implementation adapted from zsh-users/zsh-autosuggestions
# https://github.com/zsh-users/zsh-autosuggestions/blob/master/src/async.zsh
# License: MIT

# Start async git status request
function _git_async_request() {
    if [[ -n "$_GIT_ASYNC_FD" ]] && { true <&"$_GIT_ASYNC_FD" } 2>/dev/null; then
        builtin exec {_GIT_ASYNC_FD}<&-
        zle -F "$_GIT_ASYNC_FD"
        if [[ -o monitor ]]; then
            kill -TERM "-$_GIT_ASYNC_PID" 2>/dev/null
        else
            kill -TERM "$_GIT_ASYNC_PID" 2>/dev/null
        fi
    fi

    builtin exec {_GIT_ASYNC_FD}< <(
        builtin echo "${sysparams[pid]}"
        _get_git_status
    )

    is-at-least 5.8 || command true
    read -r _GIT_ASYNC_PID <&"$_GIT_ASYNC_FD"
    zle -F "$_GIT_ASYNC_FD" _git_callback
}

# Handle async git status response
function _git_callback() {
    emulate -L zsh
    local fd="$1" event="$2"
    local old_status="$GIT_STATUS"

    if [[ -z "$event" || "$event" == 'hup' ]]; then
        IFS='' read -rd '' -u "$fd" GIT_STATUS

        if [[ "$old_status" != "$GIT_STATUS" ]]; then
            zle reset-prompt
            zle -R
        fi

        builtin exec {fd}<&-
    fi

    zle -F "$fd" 2>/dev/null
    unset _GIT_ASYNC_FD
}

# Setup hook into precmd to update git status before each prompt
autoload -Uz add-zsh-hook
add-zsh-hook precmd _git_async_request
