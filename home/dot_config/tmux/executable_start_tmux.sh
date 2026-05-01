#!/bin/zsh
export PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"

SESSION_NAME="main"

# If session exists, attach; else create
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux attach -t "$SESSION_NAME"
else
    # Kill all other sessions except this one
    tmux ls 2>/dev/null | awk -F: '{print $1}' | xargs -n 1 tmux kill-session -t 2>/dev/null
    # Create new session
    tmux new-session -s "$SESSION_NAME"
fi

