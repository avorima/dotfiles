#!/usr/bin/env bash

VERSION=$1

set -e

cd ~/Downloads || exit 1
wget "https://dl.google.com/go/go$VERSION.linux-amd64.tar.gz"
cp -r ~/.local/go ~/.local/go-backup
tar -C ~/.local/go -xzf "go$VERSION.linux-amd64.tar.gz"
go version
rm -r ~/.local/go-backup
