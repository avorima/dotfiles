# If not running interactively, don't do anything
# shellcheck disable=SC1091 disable=SC1094 disable=1090
case $- in
    *i*) ;;
      *) return;;
esac

stty -ixoff -ixon

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# enable recursive globbing
shopt -s globstar

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Source global definitions
[ -f /etc/bashrc ] && . /etc/bashrc

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Colors for the prompt
__RED="\\[\\033[1;31m\\]"
__GREEN="\\[\\033[0;32m\\]"
__YELLOW="\\[\\033[1;33m\\]"
__LITEBLUE="\\[\\033[0;36m\\]"
__DARKBLUE="\\[\\033[0;34m\\]"
__CLEAR="\\[\\033[0m\\]"

if [ "$TERM" != "linux" ]; then
    __ICON_GIT_STAGE="✓"
    __ICON_GIT_DIRTY="✗"
    __ICON_PROMPT="➜"
else
    __ICON_GIT_STAGE="-"
    __ICON_GIT_DIRTY="x"
    __ICON_PROMPT="$"
fi

__git_prompt() {
    local ref state
    ref=$(git symbolic-ref HEAD 2>/dev/null | sed 's/refs\/heads\///')
    if [ "${ref}" != "" ]; then
        if git status 2>/dev/null | grep -q "Changes to be committed"; then
            state=" ${__GREEN}${__ICON_GIT_STAGE}"
        elif [ "$(git diff --shortstat 2>/dev/null)" != "" ]; then
            state=" ${__YELLOW}${__ICON_GIT_DIRTY}"
        elif git status --porcelain 2>/dev/null | grep -q "^??"; then
            state=" ${__RED}${__ICON_GIT_DIRTY}"
        fi
        echo " ${__DARKBLUE}git:(${__RED}${ref}${__DARKBLUE})${state}${__CLEAR}"
    fi
}

__set_prompt() {
    # Get last exit code
    EXIT_CODE="$?"
    current_dir="${__LITEBLUE}\\W${__CLEAR}"

    if [ "${VIRTUAL_ENV}" != "" ]; then
        venv=" ${__YELLOW}[${VIRTUAL_ENV##*/}]"
    fi
    venv="${venv}${__CLEAR}"

    kube_context=$(kubectl config current-context 2>/dev/null || echo "")
    if [ -n "${kube_context}" ]; then
        kubectx=" ${__DARKBLUE}k8s:(${__RED}${kube_context}${__DARKBLUE})"
    fi
    kubectx="${kubectx}${__CLEAR}"

    if [ ${EXIT_CODE} -ne 0 ]; then
        arrow="${__RED}${__ICON_PROMPT}${__CLEAR}"
    else
        arrow="${__GREEN}${__ICON_PROMPT}${__CLEAR}"
    fi

    PS1="${arrow}${venv} ${current_dir}${kubectx}$(__git_prompt) "
    export PS1
}

export PROMPT_COMMAND=__set_prompt

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

# Load custom completions if they exist
if [ -d ~/.bash_completion.d ]; then
    for completion in ~/.bash_completion.d/*; do
        [ -f "$completion" ] && . "$completion"
    done
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
[ -d ~/.local/kubebuilder ] && {
    PATH=$PATH:$HOME/.local/kubebuilder/bin
    KUBEBUILDER_ASSETS=$HOME/.local/kubebuilder/bin
    export KUBEBUILDER_ASSETS
}

export GOROOT=$HOME/.local/go
export GOPATH=$HOME/go
export GO111MODULE=auto

PATH=$PATH:$GOPATH/bin:$GOROOT/bin

[ -d ~/.plenv/bin ] && PATH=$HOME/.plenv/bin:$PATH && eval "$(plenv init -)"

export PATH

if [ -z "$TMUX" ]; then
    if command -v keychain 2>/dev/null; then
        eval "$(keychain --eval --agents ssh id_ed25519 id_rsa backup_id_rsa)"
        ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/auth_sock"
    fi
fi

command -v pip >/dev/null && source <(pip completion --bash)
command -v kubectl >/dev/null && source <(kubectl completion bash)
command -v kubeadm >/dev/null && source <(kubeadm completion bash)
command -v kind >/dev/null && source <(kind completion bash)
command -v helm >/dev/null && source <(helm completion bash)
command -v docker-ls >/dev/null && source <(docker-ls autocomplete bash)
command -v operator-sdk >/dev/null && source <(operator-sdk completion bash)
command -v direnv >/dev/null && eval "$(direnv hook bash)"
command -v minikube >/dev/null && source <(minikube completion bash)
command -v golangci-lint >/dev/null && source <(golangci-lint completion bash)
command -v ionosctl >/dev/null && source <(ionosctl completion bash)
command -v gopass >/dev/null && source <(gopass completion bash)

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

[ -e ~/.local/bin/mc ] && complete -C /home/mv/.local/bin/mc mc
