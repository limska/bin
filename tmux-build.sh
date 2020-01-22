#!/bin/zsh
SESSION=build
SRC="~/src/starccm/dev/star"

cd $SRC

tmux -2 new-session -d -s $SESSION -n 'git' 

# Setup a window for tailing log files
tmux new-window -t $SESSION:2 -n 'vim' -c $SRC
tmux new-window -t $SESSION:3 -n 'cmake' -c $SRC
tmux new-window -t $SESSION:4 -n 'java' -c $SRC
tmux new-window -t $SESSION:5 -n 'python' -c $SRC
tmux new-window -t $SESSION:6 -n 'rsync' -c $SRC

# Attach to session
tmux -2 attach-session -t $SESSION

