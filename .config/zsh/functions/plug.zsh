# Path for plugins
readonly _PLUGINS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"

# Source plugin file if it exists
function _load_plugin() {
    local file="$_PLUGINS_DIR/$1"
    [[ -f "$file" ]] && source "$file"
}

# Public function to load a plugin
function plug() {
    local repo="$1"
    local name="${repo##*/}"
    local dir="$_PLUGINS_DIR/$name"

    if [[ ! -d "$dir" ]]; then
        mkdir -p "$_PLUGINS_DIR"
        git clone --quiet --depth=1 "https://github.com/$repo.git" "$dir" || return 1
    fi

    _load_plugin "$name/$name.plugin.zsh" || _load_plugin "$name/$name.zsh"
}

# Public function to update all installed plugins
function plug-update() {
    local dir
    for dir in "$_PLUGINS_DIR"/*/; do
        [[ -d "$dir/.git" ]] || continue
        echo "Updating ${dir:t}..."
        git -C "$dir" pull --quiet --ff-only
    done
}
