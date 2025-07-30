zmodload zsh/system

typeset -g _GIT_ASYNC_FD
typeset -g _GIT_ASYNC_PID
typeset -g _GIT_STATUS

function _get_git_status() {
    local git_dir branch dirty head_content
    git_dir=$(git rev-parse --git-dir 2>/dev/null)
    if [[ -z "${git_dir}" ]]; then
        return
    fi
    if [[ -f "${git_dir}/HEAD" ]]; then
        head_content=$(cat "${git_dir}/HEAD" 2>/dev/null)
        if [[ "${head_content}" =~ '^ref:\ refs/heads/(.*)$' ]]; then
            branch="${match[1]}"
        elif [[ "${head_content}" =~ '^([0-9a-f]{8})[0-9a-f]+$' ]]; then
            branch="${match[1]}"
        fi
    fi
    if [[ -z "${branch}" ]]; then
        return
    fi
    if ! git diff-index --quiet HEAD 2>/dev/null; then
        dirty="*"
    fi
    echo " %F{white}${branch}${dirty}%f"
}

# Async implementation adapted from zsh-users/zsh-autosuggestions
# https://github.com/zsh-users/zsh-autosuggestions/blob/master/src/async.zsh
# License: MIT

function _git_async_request() {
    if [[ -n "${_GIT_ASYNC_FD}" ]] && { true <&"${_GIT_ASYNC_FD}" } 2>/dev/null; then
        exec {_GIT_ASYNC_FD}<&-
        zle -F "${_GIT_ASYNC_FD}"
        if [[ -o monitor ]]; then
            kill -TERM "-${_GIT_ASYNC_PID}" 2>/dev/null
        else
            kill -TERM "${_GIT_ASYNC_PID}" 2>/dev/null
        fi
    fi
    exec {_GIT_ASYNC_FD}< <(
        builtin echo ${sysparams[pid]}
        _get_git_status
    )
    command true
    read _GIT_ASYNC_PID <&"${_GIT_ASYNC_FD}"
    zle -F "${_GIT_ASYNC_FD}" _git_callback
}

function _git_callback() {
    emulate -L zsh
    local old_git_status="${_GIT_STATUS}"
    local fd_data
    if [[ -z "${2}" || "${2}" == "hup" ]]; then
        fd_data="$(cat <&${1})"
        _GIT_STATUS="${fd_data}"
        if [[ "${old_git_status}" != "${_GIT_STATUS}" ]]; then
            zle reset-prompt
            zle -R
        fi
        exec {1}<&-
    fi
    zle -F "${1}" 2>/dev/null
    unset _GIT_ASYNC_FD
}

function git_status() {
    echo "${_GIT_STATUS}"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _git_async_request
