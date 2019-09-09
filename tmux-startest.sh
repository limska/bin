#!/bin/bash
SESSION=startest

tmux -2 new-session -d -s $SESSION -n 'git'

# Setup a window for tailing log files
tmux new-window -t $SESSION:2 -n 'make' -c ~/src/starccm/dev/startest
tmux new-window -t $SESSION:3 -n 'rsync' -c ~/src/starccm/dev/startest

# Attach to session
tmux -2 attach-session -t $SESSION

