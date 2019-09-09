#!/bin/bash
SESSION=build

tmux -2 new-session -d -s $SESSION -n 'git' 

# Setup a window for tailing log files
tmux new-window -t $SESSION:2 -n 'vim' -c ~/src/starccm/dev/star
tmux new-window -t $SESSION:3 -n 'cmake' -c ~/src/starccm/dev/star
tmux new-window -t $SESSION:4 -n 'java' -c ~/src/starccm/dev/star
tmux new-window -t $SESSION:5 -n 'python' -c ~/src/starccm/dev/star
tmux new-window -t $SESSION:6 -n 'rsync' -c ~/src/starccm/dev/star

# Attach to session
tmux -2 attach-session -t $SESSION

