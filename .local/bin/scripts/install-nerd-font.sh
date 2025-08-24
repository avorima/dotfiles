#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ ${TRACE-} == "1" ]]; then
    set -o xtrace
fi

download_link=$(curl -s https://www.nerdfonts.com/font-downloads | extract-links.py -c font-preview | fzf)
font_version=$(sed 's|https://github.com/ryanoasis/nerd-fonts/releases/download/\(.*\)/.*|\1|' <<< $download_link)
font_archive=$(sed 's|https://github.com/ryanoasis/nerd-fonts/releases/download/.*/||' <<< $download_link)
font_name=${font_archive%.*}

if [[ -f ~/.local/share/fonts/$font_name ]] && [[ $(cat ~/.local/share/fonts/$font_name) == $font_version ]]; then
    echo "already installed"
    exit
fi

curl -o /tmp/$font_archive -L $download_link
unzip /tmp/$font_archive -d ~/.local/share/fonts/
echo $font_version > ~/.local/share/fonts/$font_name
fc-cache -vf ~/.local/share/fonts
echo "installed $font_name $font_version"
