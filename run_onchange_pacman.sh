#!/usr/bin/env bash

apps=(
    # editor
    neovim
    # utils
    7zip fzf rclone rsync socat gdu lsof
    # rust clis
    atuin bat btop eza git-delta gitui fd hexyl igrep
    navi nushell oryx ouch procs ripgrep starship
    tealdeer typos tokei typst tinymist yazi zoxide zellij
    # charm clis
    gum glow skate vhs
)

sudo pacman -Syu --needed "${apps[@]}"
