# dotfiles

Inspired by [this blogpost](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/).

## Installation

For a quick and simple installation:

    git clone --bare https://github.com/mvrma/dotfiles .dotfiles
    git --git-dir=~/.dotfiles --work-tree=~ checkout
    ./setup.sh

This will switch to the 'basic' branch and save existing dotfiles into `~/.dotfiles.bak`. If a .bashrc is found it also appends the `dotfiles` alias to the .bashrc and reloads it. `dotfiles` is just an alias for `git --git-dir=$HOME/.dotfiles --work-tree=$HOME`.

## Usage

setup.sh __\[OPTIONS] \[BRANCH]__

__BRANCH__ defaults to _basic_.

### Options

- __-h__

  Show help
  
- __-f, --force__

  Remove existing dotfiles instead of saving them

- __-s, --skip-vim__

  Skip installing ViM plugins with [vim-plug](https://github.com/junegunn/vim-plug)
  
- __-b, --backup__ _DIR_
 
  Moves existing files to _DIR_ instead of _.dotfiles.bak_
