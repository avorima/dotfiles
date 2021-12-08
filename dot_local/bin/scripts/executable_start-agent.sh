#!/bin/sh
if pgrep gpg-agent >/dev/null; then
    gpgconf --kill gpg-agent
    SESSION_DIR=$(find "$XDG_RUNTIME_DIR/gnupg" -type d ! -path "$XDG_RUNTIME_DIR/gnupg")
    [ -d "$SESSION_DIR" ] && rm -r "$SESSION_DIR"
fi
eval "$(gpg-agent --enable-ssh-support --daemon --homedir "$GNUPGHOME")"
