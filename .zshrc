source ~/.config/shell/default.sh

# yay -S zsh-vi-mode
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
function zvm_after_init() {
    [ -d /usr/share/fzf ] && {
        source /usr/share/fzf/key-bindings.zsh
    }
}

SESSION_DIR=$(find "$XDG_RUNTIME_DIR/gnupg" -type d ! -path "$XDG_RUNTIME_DIR/gnupg" 2>/dev/null)
if [ -z "$SESSION_DIR" ]; then
    eval "$(gpg-agent --enable-ssh-support --daemon --homedir $GNUPGHOME)"
fi

alias k=kubectl
alias kctx=kubectx
alias vim=nvim

if [ -d ~/.config/zsh/source-once ]; then
    for f in ~/.config/zsh/source-once/*; do source $f; done
    rm -r ~/.config/zsh/source-once
fi

fpath=(~/.config/zsh/functions/completion $fpath)
autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zcompdump"
_comp_options+=(globdots)

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/mcli mcli
complete -o nospace -C /home/mv/.local/bin/mc mc

zstyle ':completion:*' verbose no

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh

zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

# zstyle ':completion:*' completer _complete _match _approximate
# zstyle ':completion:*:match:*' original only
# zstyle ':completion:*:approximate:*' max-errors 1 numeric

__git_prompt() {
    local ref state
    git rev-parse --git-dir 2>/dev/null 1>&2 || return
    ref=$(git symbolic-ref HEAD 2>/dev/null | sed 's|refs/heads/||')
    [[ -z $ref ]] && ref=$(git rev-parse --short HEAD 2>/dev/null)
    [[ -z $ref ]] && ref='??'
    if [[ -n "$(git diff --staged --name-status)" ]]; then
        state=" %F{green}✔"
    elif git status --porcelain | grep -q '^\s*M'; then
        state=" %F{yellow}✗"
    elif git status --porcelain | grep -q "^??"; then
        state=" %F{red}✗"
    fi
    echo " %F{blue}git:(%F{red}${ref}%F{blue})${state}%f"
}

__kube_prompt() {
    local ctx ns
    ctx=$(kubectl config current-context 2>/dev/null)
    if [[ -z $ctx ]]; then
        return
    fi
    if command -v kubens >/dev/null 2>/dev/null; then
        ns=$(kubens -c)
    else
        ns=$(kubectl config get-contexts | grep -w "\\s${ctx}\\s" | awk '{print $4}')
        [[ -z $ns ]] && ns=default
    fi
    echo " %F{blue}k8s:(%F{red}${ctx}%F{blue}/%F{red}${ns}%F{blue})%f"
}

setopt PROMPT_SUBST
PROMPT='%(?.%F{green}.%F{red})➜%f %F{cyan}%1~%f %$(__kube_prompt) %$(__git_prompt) '

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export KREW_NO_UPGRADE_CHECK=1

eval "$(direnv hook zsh)"
