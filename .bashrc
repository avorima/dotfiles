# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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
[[ -f /etc/bashrc ]] && . /etc/bashrc

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Colors for the prompt
RED="\e[1;31m"
GREEN="\e[0;32m"
YELLOW="\e[1;33m"
LITEBLUE="\e[0;36m"
DARKBLUE="\e[0;34m"
CLEAR="\e[0m"

parse_git_dirty() {
    if [[ $(git status 2> /dev/null | grep "Changes to be committed") != "" ]]
    then
        echo "${GREEN}✓${CLEAR} "
    elif [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]
    then
        echo "${YELLOW}✗${CLEAR} "
    elif [[ $(git status --porcelain 2>/dev/null | grep "^??" | wc -l) -ne 0 ]]
    then
        echo "${RED}✗${CLEAR} "
    fi
}

git_prompt() {
    local ref=$(git symbolic-ref HEAD 2>/dev/null | cut -d'/' -f3)
    if [ "$ref" != "" ]; then
        echo "${DARKBLUE}git:(${RED}$ref${DARKBLUE})${CLEAR} $(parse_git_dirty)"
    fi
}

set_prompt() {
    # Get last exit code
    local EXIT="$?"

    current_dir="\[$LITEBLUE\]\W\[$CLEAR\]"

    if [[ $VIRTUAL_ENV != "" ]]
    then
        venv=" ${YELLOW}[${VIRTUAL_ENV##*/}]"
    else
        venv="${CLEAR}"
    fi

    if [ $EXIT -ne 0 ]; then
        arrow="${RED}➜${CLEAR}"
    else
        arrow="${GREEN}➜${CLEAR}"
    fi

    export PS1="${arrow} ${venv} ${current_dir} $(git_prompt)"
}

export PROMPT_COMMAND=set_prompt

LS_COLORS='di=1;34:fi=0;0:ln=0;35:ex=0;32:'
export LS_COLORS
export GREP_COLOR='1;33'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export PATH="/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin:/usr/local/sbin:$HOME/bin"

export BROWSER=firefox
export EDITOR=vim

# .inputrc

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

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

source ~/perl5/perlbrew/etc/bashrc

export NVM_DIR="/home/mari0/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# {{{
# Node Completion - Auto-generated, do not touch.
shopt -s progcomp
for f in $(command ls ~/.node-completion); do
  f="$HOME/.node-completion/$f"
  test -f "$f" && . "$f"
done
# }}}

source "/home/mari0/.rvm/scripts/rvm" # Load rvm
