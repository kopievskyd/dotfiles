local tty_state=new

function _tty_state_preexec() {
    if [[ "${1}" =~ '^[[:space:]]*(clear|reset|cls)' ]]; then
        tty_state=new
    else
        tty_state=old
    fi
}

function _tty_state_precmd() {
    [[ "${tty_state}" == "old" ]] && echo
}

autoload -U add-zsh-hook
add-zsh-hook preexec _tty_state_preexec
add-zsh-hook precmd _tty_state_precmd
