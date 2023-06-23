#!/bin/zsh
SESSION=blue-fox
SRC="$HOME/src"
REPOS="$HOME/repos"

cd $REPOS; tmux -2 new-session -d -s $SESSION -n 'repos'

# Setup a window for tailing log files
tmux new-window -t $SESSION:2 -n 'amt-services' -c $REPOS/amt-services
tmux new-window -t $SESSION:3 -n 'bf-services' -c $REPOS/amt-services/blue-fox
tmux new-window -t $SESSION:4 -n 'at-framework' -c $REPOS/amt-services/acceptance-test-framework
tmux new-window -t $SESSION:5 -n 'frontend' -c $REPOS/frontend
tmux new-window -t $SESSION:6 -n 'cp-service' -c $REPOS/cutting-params-service/projects/cutting-params-service
tmux new-window -t $SESSION:7 -n 'cp-at' -c $REPOS/cutting-params-service/projects/cutting-parameters-acceptance-test
tmux new-window -t $SESSION:8 -n 'cp-git' -c $REPOS/cutting-params-service
tmux new-window -t $SESSION:9 -n 'engine' -c $REPOS/engine

# Attach to session
tmux -2 attach-session -t $SESSION

