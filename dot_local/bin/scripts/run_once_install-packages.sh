#!/usr/bin/env bash
set -eo pipefail

case "$(grep '^ID=' /etc/os-release | cut -d= -f2)" in
    arch)
        echo "running post-install steps for Arch Linux"
        sudo pacman -S --needed git base-devel go kubectl kubeseal \
            zsh-completions terraform alacritty direnv helm flameshot \
            minio-client neofetch neovim podman podman-docker networkmanager \
            networkmanager-openvpn skopeo skaffold jq xh go-yq ripgrep
        if ! command -v yay >/dev/null; then
            git clone https://aur.archlinux.org/yay.git /tmp/yay
            (
                cd /tmp/yay
                sudo makepkg -si
            )
        fi
        yay -S --needed tmux-fastcopy nerd-fonts-complete kubectl-neat \
            zsh-vi-mode
        ;;
esac
