# vim: ft=bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.config/shell/default.sh
export KREW_NO_UPGRADE_CHECK=1

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups

# enable recursive globbing
shopt -s globstar

PS1='[\u@\h \W]\$ '

[ -e /usr/bin/mcli ] && complete -C /usr/bin/mcli mcli

command -v direnv >/dev/null && eval "$(direnv hook bash)"
