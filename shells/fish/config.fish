if status is-interactive
    fish_vi_key_bindings
    set -g fish_cursor_default block
    set -g fish_cursor_insert line
    set -g fish_cursor_replace underscore
    set -g fish_cursor_replace_one underscore

    source "$__fish_config_dir/aliases.fish"
    source "$__fish_config_dir/tools.fish"
end
