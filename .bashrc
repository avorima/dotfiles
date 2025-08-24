# If not running interactively, don't do anything
# shellcheck disable=SC1091 disable=SC1094 disable=1090
case $- in
    *i*) ;;
      *) return;;
esac

stty -ixoff -ixon

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# enable recursive globbing
shopt -s globstar

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Source global definitions
[ -f /etc/bashrc ] && . /etc/bashrc

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Colors for the prompt
RED="\\[\\033[1;31m\\]"
GREEN="\\[\\033[0;32m\\]"
YELLOW="\\[\\033[1;33m\\]"
LITEBLUE="\\[\\033[0;36m\\]"
DARKBLUE="\\[\\033[0;34m\\]"
CLEAR="\\[\\033[0m\\]"

if [ "$TERM" != "linux" ]; then
    ICON_GIT_CLEAN="✓"
    ICON_GIT_DIRTY="✗"
    ICON_PROMPT="➜"
else
    ICON_GIT_CLEAN="."
    ICON_GIT_DIRTY="x"
    ICON_PROMPT="$"
fi

parse_git_dirty() {
    if [[ $(git status 2> /dev/null | grep "Changes to be committed") != "" ]]
    then
        echo "${GREEN}${ICON_GIT_CLEAN}${CLEAR} "
    elif [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]
    then
        echo "${YELLOW}${ICON_GIT_DIRTY}${CLEAR} "
    elif [[ $(git status --porcelain 2>/dev/null | grep -c "^??") -ne 0 ]]
    then
        echo "${RED}${ICON_GIT_DIRTY}${CLEAR} "
    fi
}

git_prompt() {
    local ref
    ref=$(git symbolic-ref HEAD 2>/dev/null | sed 's/refs\/heads\///')
    if [ "$ref" != "" ]; then
        echo "${DARKBLUE}git:(${RED}$ref${DARKBLUE})${CLEAR} $(parse_git_dirty)"
    fi
}

set_prompt() {
    # Get last exit code
    local EXIT="$?"
    local current_dir="${LITEBLUE}\\W${CLEAR}"

    if [[ $VIRTUAL_ENV != "" ]]
    then
        venv=" ${YELLOW}[${VIRTUAL_ENV##*/}]"
    else
        venv="${CLEAR}"
    fi

    if [ $EXIT -ne 0 ]; then
        arrow="${RED}${ICON_PROMPT}${CLEAR}"
    else
        arrow="${GREEN}${ICON_PROMPT}${CLEAR}"
    fi

    PS1="${arrow} ${venv} ${current_dir} $(git_prompt)"
    export PS1
}

export PROMPT_COMMAND=set_prompt

LS_COLORS='di=1;34:fi=0;0:ln=0;35:ex=0;32:'
export LS_COLORS
export GREP_COLOR='1;33'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export BROWSER=firefox
export EDITOR=vim
export LIBVIRT_DEFAULT_URI=qemu:///system
export ETCDCTL_API=3

[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="$HOME/.nvm"
if [ -d "$NVM_DIR" ]; then
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
fi

# Node Completion - Auto-generated, do not touch.
shopt -s progcomp
if [ -d "$HOME/.node-completion" ]; then
    for f in $(command ls ~/.node-completion); do
        f="$HOME/.node-completion/$f"
        test -f "$f" && . "$f"
    done
fi

export RVM_DIR="$HOME/.rvm"
if [ -d "$RVM_DIR" ]; then
    . "$RVM_DIR/scripts/rvm" # Load rvm
fi

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export GOROOT=$HOME/.local/go
export GOPATH=$HOME/go
export GO111MODULE=auto

PATH=$PATH:$GOROOT/bin:$GOPATH/bin

[ -d ~/.plenv/bin ] && PATH=$HOME/.plenv/bin:$PATH && eval "$(plenv init -)"

export PATH

if [ -z "$TMUX" ]; then
    eval "$(keychain --eval --agents ssh id_rsa backup_id_rsa)"
    ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/auth_sock"
fi

type -p kubectl >/dev/null && source <(kubectl completion bash)
type -p kubeadm >/dev/null && source <(kubeadm completion bash)
type -p helm >/dev/null && source <(helm completion bash)
type -p docker-ls >/dev/null && source <(docker-ls autocomplete bash)
type -p operator-sdk >/dev/null && source <(operator-sdk completion bash)

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

fkill() {
    local pid
    if [ "$UID" != 0 ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]; then
        echo "$pid" | xargs kill -"${1:-9}"
    fi
}
