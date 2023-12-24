if [ "$(command -v nvim)" ]; then
	alias vi=nvim
	alias vim=nvim
fi
if [ "$(command -v fdfind)" ]; then
	alias fd=fdfind
fi
if [ "$(command -v batcat)" ]; then
	alias bat=batcat
fi
if [ "$(command -v exa)" ]; then
	alias ls='exa'
	alias ll='exa -al'
	alias la='exa -a'
	alias l='exa -l'
fi

# use NVIM_APPNAME to use various neovim distros
alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"
alias nvim-nvchad="NVIM_APPNAME=NvChad nvim"
function nvims() {
  items=("default" "LazyVim" "NvChad")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config >> " --height=50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim "$@"
}

# use win32yank.exe
# ln -s /mnt/c/Users/fadei/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code .
# ln -s /mnt/c/Windows/explorer.exe ii
# ln -s /mnt/c/Windows/System32/clip.exe .
