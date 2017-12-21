#!/bin/bash

RED="\e[0;31m"
GREEN="\e[0;32m"
CLEAR="\e[0m"

function dotfiles()
{
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME $@
}

function swap()
{
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE $2
}

function log_success()
{
    echo -e "${GREEN}$1${CLEAR}"
}

function log_error()
{
    echo -e "${RED}$1${CLEAR}"
}

function on_error()
{
    log_error "Setup failed: $@"
    exit 1
}

function show_help()
{
    echo "Usage: setup.sh [OPTIONS] [--] [BRANCH]"
    echo ""
    echo "  Switch to BRANCH (default=master) and set it up"
    echo ""
    echo "Options:"
    echo "    -h | --help           Show this message and exit"
    echo "    -f | --force          Force checkout, removing existing files"
    echo "    -s | --skip-vim       Don't install ViM plugins"
    echo "    -b | --backup DIR     Move existing files to DIR (default=.dotfiles.bak)"
    echo ""
}

OPTIND=1
declare HELP=false
declare INSTALL_PLUGINS=true
declare FORCE_CHECKOUT=false
declare BRANCH="basic"
declare BACKUP_DIR="$HOME/.dotfiles.bak"

for arg in "$@"; do
    shift
    case "$arg" in
	"--help")     set -- "$@" "-h" ;;
	"--force")    set -- "$@" "-f" ;;
	"--skip-vim") set -- "$@" "-s" ;;
	"--backup")   set -- "$@" "-b" ;;
	*)            set -- "$@" "$arg"
    esac
done

while getopts "hfsb:" opt; do
    case "$opt" in
        h) HELP=true ;;
        f) FORCE_CHECKOUT=true ;;
        s) INSTALL_PLUGINS=false ;;
        b) BACKUP_DIR=$OPTARG ;;
    esac
done

$HELP && show_help && exit 0

shift $((OPTIND-1))

[[ "$1" = "--" ]] && shift

[[ $# -gt 1 ]] && on_error "Too many arguments"

[[ -n $1 ]] && BRANCH=$1

dotfiles branch | grep $BRANCH > /dev/null 2>&1
[[ $? -ne 0 ]] && on_error "Branch '$BRANCH' does not exist"

dotfiles checkout $BRANCH > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    if [[ $FORCE_CHECKOUT ]]; then
        dotfiles checkout $BRANCH 2>&1 | egrep "\s+\." | awk '{ print $1 }' | cut -d "/" -f1 | xargs -I{} rm -rf {}
        log_success "Removed existing dotfiles."
    else
        mkdir -p $BACKUP_DIR
        dotfiles checkout $BRANCH 2>&1 | egrep "\s+\." | awk '{ print $1 }' | cut -d "/" -f1 | xargs -I{} mv {} $BACKUP_DIR/{}
        log_success "Moved existing dotfiles to '$BACKUP_DIR'."
    fi
    dotfiles checkout $BRANCH > /dev/null 2>&1
    [[ $? -ne 0 ]] && on_error "Error during checkout '$BRANCH'"
fi
log_success "Switched to branch '$BRANCH'."

dotfiles config --local status.showUntrackedFiles no

# Append dotfiles alias to .bashrc
if [ -f "~/.bashrc" ]; then
    echo "alias dotfiles='git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'" >> ~/.bashrc
    source ~/.bashrc
fi

if [[ $INSTALL_PLUGINS ]]; then
    # Download vim-plug
    curl -fsLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    
    # Copy the plugin part into a new vimrc
    head -n `grep -n "Plugin End }}}" ~/.vimrc | cut -f1 -d:` ~/.vimrc > ~/.vimrc.plugin

    # Store vimrc
    swap ~/.vimrc ~/.vimrc.plugin

    # Install plugins and quit vim
    vim -c PlugInstall -c qa

    # Restore vimrc
    swap ~/.vimrc.plugin ~/.vimrc
    rm ~/.vimrc.plugin

    # Fill .vim folder
    mkdir -p ~/.vim/{backup,undo,swap,cache}

    log_success "Installed ViM plugins."
fi

log_success "Setup complete."
