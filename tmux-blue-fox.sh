#!/bin/zsh
SESSION=blue-fox
SRC="$HOME/src"

cd $SRC; tmux -2 new-session -d -s $SESSION -n 'src'

# Setup a window for tailing log files
tmux new-window -t $SESSION:2 -n 'amt-services' -c $SRC/amt-services
tmux new-window -t $SESSION:3 -n 'blue-fox-services' -c $SRC/amt-services/blue-fox
tmux new-window -t $SESSION:4 -n 'frontend' -c $SRC/frontend
tmux new-window -t $SESSION:5 -n 'cutting-params-service' -c $SRC/cutting-params-service/project/cutting-params-service
tmux new-window -t $SESSION:6 -n 'acceptance-test' -c $SRC/cutting-params-service/project/cutting-parameters-acceptance-test

# Attach to session
tmux -2 attach-session -t $SESSION

