source ~/.config/shell/default.sh

source ~/.local/zsh-vi-mode/zsh-vi-mode.zsh
function zvm_after_init() {
    [ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh
}

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

zstyle ':completion:*:make:*:targets' call-command true # run make to generate make targets
zstyle ':completion:*:*:make:*' tag-order 'targets'     # prioritize targets over variables/files

zstyle ':completion:*' rehash true

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
    if ns=$(kubectl ns -c 2>/dev/null) && test -n "$ns"; then
        echo " %F{blue}k8s:(%F{red}${ctx}%F{blue}/%F{red}${ns}%F{blue})%f"
    else
        echo " %F{blue}k8s:(%F{red}${ctx}%F{blue}%f"
    fi
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

function update_zsh_vi_mode() {
   (cd ~/.local/zsh-vi-mode; git pull;)
}

command -v direnv >/dev/null && eval "$(direnv hook zsh)"

if test -n "$KITTY_INSTALLATION_DIR"; then
    export KITTY_SHELL_INTEGRATION="enabled"
    autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
    kitty-integration
    unfunction kitty-integration
fi
