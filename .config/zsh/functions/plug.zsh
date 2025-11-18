# Path for plugins
readonly _PLUGINS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"

# Source plugin file if exists
function _load_plugin() {
    local file="$_PLUGINS_DIR/$1"
    [[ -f $file ]] && source "$file"
}

# Public function to load plugin
function plug() {
    local repo="$1"
    local name="${repo##*/}"
    local dir="$_PLUGINS_DIR/$name"
    [[ -d $_PLUGINS_DIR ]] || mkdir -p "$_PLUGINS_DIR"
    [[ -d $dir ]] || git clone --depth=1 "https://github.com/$repo.git" "$dir"
    _load_plugin "$name/$name.plugin.zsh" || _load_plugin "$name/$name.zsh"
}
