#!/usr/bin/env bash
set -eo pipefail

echo "running post-install steps for Arch Linux"

if [[ ! -e ~/.config/nvim/autoload/plug.vim ]]; then
    echo "installing vim-plug"
    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo "installing packages"
sudo pacman -S --needed \
    base-devel \
    man \
    vim \
    neovim \
    direnv \
    alacritty \
    tmux \
    zsh \
    zsh-completions \
    go \
    jq \
    go-yq \
    ripgrep \
    gopass \
    sops \
    xh \
    gopls \
    python-lsp-server \
    neofetch \
    xsel \
    wl-clipboard

if ! command -v yay >/dev/null; then
    echo "installing AUR helper"
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (
        cd /tmp/yay
        makepkg -si
    )
fi

yay -S --needed tmux-plugin-manager tmux-fastcopy zsh-vi-mode nerd-fonts-source-code-pro vim-language-server
printf "install additional packages? (y/N) "
read -r yn
if [[ $yn = "y" ]]; then
    echo "installing additional development packages"
    sudo pacman -S --needed \
        kubectl \
        kubeseal \
        skopeo \
        helm \
        minio-client \
        podman \
        podman-docker
    yay -S --needed kubectl-neat
fi

echo "finished post-install steps for Arch Linux"
