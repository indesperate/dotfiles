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

if command -v nvim >/dev/null 2>&1; then
    export EDITOR=nvim
    export MANPAGER='nvim +Man!'
fi

if command -v go >/dev/null 2>&1; then
    export GOPATH="$HOME/.go"
fi
