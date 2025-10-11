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

unset append_path

export PATH

export FZF_DEFAULT_OPTS=" \
--color=spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'
  --color header:italic"
# --header 'CTRL-Y to copy, CTRL-/ to preview'"

if [ "$(command -v nvim)" ]; then
  export EDITOR=nvim
  export MANPAGER='nvim +Man!'
fi

export GOPATH=$HOME/.go

# openrouter

if [ "$(command -v skate)" ]; then
  OPENROUTER_API_KEY=$(skate get openrouter_api_key)
  export OPENROUTER_API_KEY
fi
