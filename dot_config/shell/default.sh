export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export GNUPGHOME=$XDG_DATA_HOME/gnupg
export KREW_ROOT=$HOME/.local/krew
# See https://github.com/npm/npm/issues/6675
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/config
export NPM_CONFIG_CACHE=$XDG_CACHE_HOME/npm
export NPM_CONFIG_TMP=$XDG_RUNTIME_DIR/npm
export PYTHONSTARTUP=$XDG_CONFIG_HOME/pythonrc
export MYSQL_HISTFILE=/dev/null
export VAGRANT_HOME=$XDG_DATA_HOME/vagrant
export VAGRANT_ALIAS_FILE=$XDG_DATA_HOME/vagrant/aliases
export K9SCONFIG=$XDG_CONFIG_HOME/k9s
# export GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
# export KDEHOME=$XDG_CONFIG_HOME/kde

SESSION_DIR=$(find "$XDG_RUNTIME_DIR/gnupg" -type d ! -path "$XDG_RUNTIME_DIR/gnupg" 2>/dev/null)
[ -d "$SESSION_DIR" ] && {
    export GPG_AGENT_INFO=$SESSION_DIR/S.gpg-agent
    export SSH_AUTH_SOCK=$SESSION_DIR/S.gpg-agent.ssh
}

[ -d ~/.local/kubebuilder ] && {
    KUBEBUILDER_ASSETS=$HOME/.local/kubebuilder/bin
    PATH=$PATH:$KUBEBUILDER_ASSETS
    export KUBEBUILDER_ASSETS
}


PATH=$HOME/.local/bin:$HOME/.local/bin/scripts:$HOME/go/bin:$KREW_ROOT/bin:$PATH
export PATH

export EDITOR=/usr/bin/nvim

export HISTSIZE=1000

alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lhA --color=auto --group-directories-first'
alias lt='ls -lht --color=auto --group-directories-first'
alias ..='cd ..'

alias sssh='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias sscp='scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

[ -e /usr/bin/man ] && alias man='LC_ALL=en_US.UTF-8 /usr/bin/man'
[ -e /usr/bin/wget ] && alias wget='/usr/bin/wget --hsts-file=$XDG_CACHE_HOME/wget-hsts'
[ -e /usr/bin/mcli ] && alias mcli='/usr/bin/mcli --config-dir=$XDG_CONFIG_HOME/mcli'
