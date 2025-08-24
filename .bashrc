# shellcheck shell=bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.config/shell/default.sh

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups

# enable recursive globbing
shopt -s globstar

PS1='[\u@\h \W]\$ '

command -v direnv >/dev/null && eval "$(direnv hook bash)"
