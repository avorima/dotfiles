source ~/.config/shell/default.sh

# yay -S zsh-vi-mode
# function zvm_config() {
#     ZVM_TERM=alacritty-256color
#     ZVM_VI_HIGHLIGHT_BACKGROUND=#cc241d
#     ZVM_CURSOR_STYLE_ENABLED=true
#     ZVM_INSERT_MODE_CURSOR=ZVM_CURSOR_BLINKING_BEAM
#     ZVM_NORMAL_MODE_CURSOR=ZVM_CURSOR_BLINKING_BLOCK
# }
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.zsh
function zvm_after_init() {
    [ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
}

alias k=kubectl
alias kctx=kubectx
alias vim=nvim
alias S='sudo pacman -Syu'

if [ -d ~/.config/zsh/source-once ]; then
    for f in ~/.config/zsh/source-once/*; do source $f; done
    rm -r ~/.config/zsh/source-once
fi

fpath=(~/.config/zsh/functions/completion $fpath)
autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zcompdump"
_comp_options+=(globdots)

autoload -U +X bashcompinit && bashcompinit
[ -e /usr/bin/mcli ] && complete -o nospace -C /usr/bin/mcli mcli

zstyle ':completion:*' verbose no

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh

zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

zstyle ':completion:*' rehash true

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
# allow bash-style commenting on the command-line
setopt INTERACTIVE_COMMENTS

command -v direnv >/dev/null && eval "$(direnv hook zsh)"

if test -n "$KITTY_INSTALLATION_DIR"; then
    export KITTY_SHELL_INTEGRATION="enabled"
    autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
    kitty-integration
    unfunction kitty-integration
fi
