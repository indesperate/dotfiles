#!/usr/bin/env bash

# install essential software
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y vim tmux git zsh
sudo apt-get install -y rsync aria2 p7zip-full
sudo apt-get install -y ffmpeg pandoc
sudo apt-get install -y build-essential gdb cmake
sudo apt-get install -y nnn fd-find tldr bat tree
sudo apt-get install -y exa ripgrep shellcheck fzf dust httpie broot pv

# configure vim
cat >> ~/.vimrc << EOF
set number
set relativenumber
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)
set showcmd
EOF

# configure tmux
touch ~/.tmux.conf
cat >> ~/.tmux.conf << EOF 
set -g prefix C-a
setw -g mode-keys vi
unbind-key C-b
bind h select-pane -L
bind l select-pane -R
bind k select-pane -U
bind j select-pane -D
bind -n M-j previous-window
bind -n M-k next-window
bind | split-window -h
bind - split-window -v
EOF

touch ~/.bash_aliases
cat >> ~/.bash_aliases << EOF
alias vim=nvim
alias vi=nvim
alias fd=fdfind
alias bat=batcat
alias ls='exa'
alias ll='exa -al'
alias la='exa -a'
alias l='exa -l'
EOF

cat >> ~/.bashrc << EOF
if [ -d "\$HOME/.local/bin" ] ; then
    export PATH="\$HOME/.local/bin:\$PATH"
fi
if [ -d "\$HOME/.local/lib" ] ; then
    export LD_LIBRARY_PATH="\$HOME/.local/bin:\$LD_LIBRARY_PATH"
    export LIBRARY_PATH="\$HOME/.local/bin:\$LIBRARY_PATH"
fi

bind -m vi "v":edit-and-execute-command
export EDITOR=nvim
source /usr/share/doc/fzf/examples/key-bindings.bash
eval "\$(starship init bash)"
eval "\$(zoxide init bash)"
EOF









