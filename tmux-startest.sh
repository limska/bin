#!/bin/bash
SESSION=startest

tmux -2 new-session -d -s $SESSION

# Setup a window for tailing log files
tmux new-window -t $SESSION:1 -n 'git'
tmux new-window -t $SESSION:2 -n 'make'
tmux new-window -t $SESSION:3 -n 'rsync'

# Attach to session
tmux -2 attach-session -t $SESSION

