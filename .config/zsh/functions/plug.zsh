# Path for plugins
if (( ! ${+_PLUGINS_DIR} )); then
    readonly _PLUGINS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"
fi

# Public function to load a plugin
function plug() {
    emulate -L zsh

    (( $# == 1 )) || return 1

    local repo="$1"
    local name="${repo##*/}"
    local dir="$_PLUGINS_DIR/$name"
    local file

    if [[ ! -d "$dir" ]]; then
        mkdir -p "$_PLUGINS_DIR"
        git clone --quiet --depth=1 "https://github.com/$repo.git" "$dir" || {
            rm -rf -- "$dir"
            return 1
        }
    fi

    if [[ -f "$dir/$name.plugin.zsh" ]]; then
        file="$dir/$name.plugin.zsh"
    elif [[ -f "$dir/$name.zsh" ]]; then
        file="$dir/$name.zsh"
    else
        return 1
    fi

    source "$file"
}

# Public function to update all installed plugins
function plug_update() {
    emulate -L zsh

    local dir
    for dir in "$_PLUGINS_DIR"/*(N/); do
        [[ -d "$dir/.git" ]] || continue
        print "Updating ${dir:t}..."
        git -C "$dir" pull --quiet --ff-only
    done
}
