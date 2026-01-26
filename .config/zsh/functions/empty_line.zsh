local _tty_state=new

function _tty_preexec() {
    [[ $1 =~ '^[[:space:]]*(clear|reset|cls)' ]] && _tty_state=new || _tty_state=old
}

function _tty_precmd() {
    [[ $_tty_state == old ]] && echo
}

autoload -U add-zsh-hook
add-zsh-hook preexec _tty_preexec
add-zsh-hook precmd _tty_precmd
