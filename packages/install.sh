#!/usr/bin/env sh

git clone --depth 1 "https://github.com/ryanoasis/nerd-fonts"
cd nerd-fonts
./install.sh
cd - > /dev/null
