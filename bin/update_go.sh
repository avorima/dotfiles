#!/usr/bin/env bash

VERSION=$1

set -e

cd ~/Downloads || exit 1

echo "Fetching go $VERSION..."
wget "https://dl.google.com/go/go$VERSION.linux-amd64.tar.gz"

echo "Copying old go files..."
if command -v rsync >/dev/null; then
    rsync -ah ~/.local/go ~/.local/go-backup
else
    cp -r  ~/.local/go ~/.local/go-backup
fi

echo "Deleting GOROOT"
sudo rm -rf ~/.local/go

echo "Extracting tarball..."
tar -C ~/.local -xzf "go$VERSION.linux-amd64.tar.gz"

echo -n "Remove backup? (y/N)"
read -r yn
[[ $yn == "y" ]] && sudo rm -rf ~/.local/go-backup
