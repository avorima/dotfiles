# shellcheck shell=bash
# shellcheck disable=SC1090,SC1091

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.config/shell/default.sh

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups

# enable recursive globbing
shopt -s globstar

PROMPT_COMMAND=__prompt_command

__prompt_command() {
    local exitcode=$?

    local reset='\[\e[0m\]'
    local red='\[\e[0;31m\]'
    local green='\[\e[0;32m\]'
    local yellow='\[\e[0;33m\]'
    local blue='\[\e[0;34m\]'
    local cyan='\[\e[0;36m\]'
    local bred='\[\e[1;31m\]'
    local bgreen='\[\e[1;32m\]'

    PS1=
    if [ $exitcode != 0 ]; then
        PS1+=${bred}
    else
        PS1+=${bgreen}
    fi

    PS1+="${exitcode} ${cyan}\W "

    local ctx ns

    KUBECONFIG=${KUBECONFIG-~/.kube/config}
    if [[ -f ${KUBECONFIG} ]]; then
        ctx=$(yq '.current-context' "${KUBECONFIG}" 2>/dev/null)
        if [[ -n $ctx ]]; then
            ns=$(yq ".contexts[]|select(.name==\"${ctx}\")|.context.namespace" "${KUBECONFIG}" 2>/dev/null)
            if [[ -z $ns ]] || [[ $ns == "null" ]]; then
                ns=default
            fi
            PS1+="${blue}k8s:(${red}${ctx}${blue}/${red}${ns}${blue}) "
        fi
    fi

    if git rev-parse --git-dir &>/dev/null; then
        local ref
        ref=$(git symbolic-ref HEAD 2>/dev/null | sed 's|refs/heads/||')
        [[ -z $ref ]] && ref=$(git rev-parse --short HEAD 2>/dev/null)
        [[ -z $ref ]] && ref='??'
        PS1+="${blue}git:(${red}${ref}${blue}) "
        if [[ -n "$(git diff --staged --name-status)" ]]; then
            PS1+=${green}
        elif git status --porcelain | grep -q '^\s*M'; then
            PS1+=${yellow}
        elif git status --porcelain | grep -q "^??"; then
            PS1+=${red}
        fi
        PS1+="+ "
    fi

    PS1+="${reset}"
}

command -v direnv >/dev/null && eval "$(direnv hook bash)"

if test -n "$KITTY_INSTALLATION_DIR"; then
    export KITTY_SHELL_INTEGRATION="enabled"
    source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
fi
