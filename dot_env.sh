append_path() {
    if [ -d "$1" ]; then
        case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH=$1${PATH:+:${PATH}} ;;
        esac
    fi
}

append_path "$HOME/bin"
append_path "$HOME/.local/bin"
append_path "$HOME/.bun/bin/"

unset append_path

export PATH

# Shared Catppuccin palette with terminal-default backgrounds.
export FZF_DEFAULT_OPTS_FILE="$HOME/.config/fzfrc"

if [ "$(command -v nvim)" ]; then
    export EDITOR=nvim
    export MANPAGER='nvim +Man!'
fi

export GOPATH=$HOME/.go
