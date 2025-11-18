# Defers command execution until shell is idle
# Based on romkatv/zsh-defer: https://github.com/romkatv/zsh-defer
# License: GPL-3.0

# Save current shell options
declare -a _defer_saved_opts=()
[[ ! -o 'aliases' ]] || _defer_saved_opts+=('aliases')
[[ ! -o 'sh_glob' ]] || _defer_saved_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || _defer_saved_opts+=('no_brace_expand')

# Set required options for reliable parsing
builtin setopt no_aliases no_sh_glob brace_expand

# Global task queue
typeset -ga _defer_tasks=()

# Default options: 1=stdout, 2=stderr, d=chpwd, m=precmd
readonly DEFER_DEFAULT_OPTS='12dm'

# Schedule task processing when shell becomes idle
function _defer_schedule() {
    exec {fd}</dev/null
    zle -F $fd _defer_resume
}

# Process queued tasks
function _defer_resume() {
    emulate -L zsh
    local fd=$1
    zle -F $fd
    exec {fd}>&-
    _defer_process_tasks
    (($#_defer_tasks)) && _defer_schedule
    return 0
}

zle -N _defer_resume

# Execute tasks while shell is idle
function _defer_process_tasks() {
    while (($#_defer_tasks && !KEYS_QUEUED_COUNT && !PENDING)); do
        local task=${_defer_tasks[1]}
        _defer_execute_task "$task"
        shift _defer_tasks
    done
}

# Execute deferred command
function _defer_execute_task() {
    local task_spec="$1"
    local opts="${task_spec%% *}"
    local cmd="${task_spec#* }"
    local original_dir="${(%):-%/}"
    local -i stdout_fd=-1 stderr_fd=-1
    [[ $opts == *1* ]] && exec {stdout_fd}>&1 1>/dev/null
    [[ $opts == *2* ]] && exec {stderr_fd}>&2 2>/dev/null
    {
        "${(@Q)${(z)cmd}}"
        _defer_run_hooks "$opts" "$original_dir"
        } always {
        ((stdout_fd >= 0)) && exec 1>&$stdout_fd {stdout_fd}>&-
        ((stderr_fd >= 0)) && exec 2>&$stderr_fd {stderr_fd}>&-
    }
}

# Execute hooks
function _defer_run_hooks() {
    emulate -L zsh
    local opts="$1"
    local original_dir="$2"
    local current_dir="${(%):-%/}"
    local hook hooks=()
    [[ $opts == *d* && $current_dir != $original_dir ]] && {
        hooks+=($chpwd $chpwd_functions)
    }
    [[ $opts == *m* ]] && {
        hooks+=($precmd $precmd_functions)
    }
    for hook in $hooks; do
        (($ + functions[$hook])) || continue
        $hook
        emulate -L zsh
    done
}

# Public function
function defer() {
    local opts="$DEFER_DEFAULT_OPTS"
    local cmd="${(@q)@}"
    (($#_defer_tasks)) || _defer_schedule
    _defer_tasks+="$opts $cmd"
}

# Restore original options
(($#_defer_saved_opts)) && builtin setopt ${_defer_saved_opts[@]}
builtin unset _defer_saved_opts
