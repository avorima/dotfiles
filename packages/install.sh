#!/usr/bin/env sh

if [ ! -e $HOME/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi

if [ ! -e nerd-fonts ]; then
    git clone --depth 1 https://github.com/ryanoasis/nerd-fonts
    cd nerd-fonts
    ./install.sh
    cd - > /dev/null
fi
