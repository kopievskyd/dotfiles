# Defer implementation adapted from romkatv/zsh-defer
# https://github.com/romkatv/zsh-defer/blob/master/zsh-defer.plugin.zsh
# License: GPL-3.0

'builtin' 'local' '-a' '_defer_opts'
[[ ! -o 'aliases'         ]] || _defer_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || _defer_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || _defer_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

typeset -ga _defer_tasks

function _defer_reset_autosuggestions() {
    unsetopt warn_nested_var
    orig_buffer=
    orig_postdisplay=
}
zle -N _defer_reset_autosuggestions

function _defer_schedule() {
    local fd
    if [[ $1 == 0 ]]; then
        exec {fd}</dev/null
    else
        zmodload zsh/zselect
        exec {fd}< <(zselect -t $1)
    fi
    zle -F $fd _defer_resume
}

function _defer_resume() {
    emulate -L zsh
    zle -F $1
    exec {1}>&-
    while (( $#_defer_tasks && !KEYS_QUEUED_COUNT && !PENDING )); do
        local delay=${_defer_tasks[1]%% *}
        local task=${_defer_tasks[1]#* }
        if [[ $delay == 0 ]]; then
            _defer_apply $task
            shift _defer_tasks
        else
            _defer_schedule $delay
            _defer_tasks[1]="0 $task"
            return 0
        fi
    done
    (( $#_defer_tasks )) && _defer_schedule 0
    return 0
}
zle -N _defer_resume

function _defer_apply() {
    local opts=${1%% *}
    local cmd=${1#* }
    local dir=${(%):-%/}
    local -i fd1=-1 fd2=-1
    [[ $opts == *1* ]] && exec {fd1}>&1 1>/dev/null
    [[ $opts == *2* ]] && exec {fd2}>&2 2>/dev/null
    {
        "${(@Q)${(z)cmd}}"
        emulate -L zsh
        local hook hooks
        [[ $opts == *d* && ${(%):-%/} != $dir ]] && hooks+=($chpwd  $chpwd_functions)
        [[ $opts == *m*                       ]] && hooks+=($precmd $precmd_functions)
        for hook in $hooks; do
            (( $+functions[$hook] )) || continue
            $hook
            emulate -L zsh
        done
        [[ $opts == *s* && $+ZSH_AUTOSUGGEST_STRATEGY    == 1 ]] && zle _defer_reset_autosuggestions
        [[ $opts == *z* && $+_ZSH_HIGHLIGHT_PRIOR_BUFFER == 1 ]] && _ZSH_HIGHLIGHT_PRIOR_BUFFER=
        [[ $opts == *p* ]] && zle reset-prompt
        [[ $opts == *r* ]] && zle -R
        } always {
        (( fd1 >= 0 )) && exec 1>&$fd1 {fd1}>&-
        (( fd2 >= 0 )) && exec 2>&$fd2 {fd2}>&-
    }
}

function defer() {
    local opts=12dmszpr
    local cmd="${(@q)@}"
    [[ $opts == *p* && $+RPS1 == 0 ]] && RPS1=
    (( $#_defer_tasks )) || _defer_schedule 0
    _defer_tasks+="0 $opts $cmd"
}

(( ${#_defer_opts} )) && setopt ${_defer_opts[@]}
'builtin' 'unset' '_defer_opts'
