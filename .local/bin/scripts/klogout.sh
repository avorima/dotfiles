#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if tmux list-sessions >/dev/null; then
    # kill all active tmux sessions
    tmux list-sessions | while read -r session _; do tmux kill-session -t "${session%:}"; done
fi

# trigger logout without prompt
qdbus org.kde.Shutdown /Shutdown logout
