readonly _PATH_TO_PLUGINS="${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/plugins"

function _load_plugin() {
    local plugin_file="${_PATH_TO_PLUGINS}/${1}"
    if [[ -f "${plugin_file}" ]]; then
        source "${plugin_file}"
    fi
}

function plug() {
    local github_repo="${1}"
    local plugin_name="${github_repo##*/}"
    local plugin_dir="${_PATH_TO_PLUGINS}/${plugin_name}"
    if [[ ! -d "${_PATH_TO_PLUGINS}" ]]; then
        mkdir -p "${_PATH_TO_PLUGINS}"
    fi
    if [[ ! -d "${plugin_dir}" ]]; then
        git clone --depth=1 "https://github.com/${github_repo}.git" "${plugin_dir}"
    fi
    _load_plugin "${plugin_name}/${plugin_name}.plugin.zsh" || \
        _load_plugin "${plugin_name}/${plugin_name}.zsh"
}
