#!/bin/bash

sudo apt update
sudo apt install nala
sudo nala install -y build-essential cgdb valgrind \
    fzf ripgrep shellcheck shfmt fd-find exa tmux \
    git htop zoxide bat
