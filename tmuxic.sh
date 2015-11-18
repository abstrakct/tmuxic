#!/bin/sh
trap 'echo -ne "\e]0;tmusic\007"' DEBUG
tmux new-session -d -s muxic
tmux new-window -t muxic '/home/rolf/bin/tmuxic/cover.sh'
tmux split-window -t muxic -v 'ncmpcpp'
tmux select-pane -t muxic -U
tmux split-window -t muxic -h '/home/rolf/bin/tmuxic/cover_back.sh'
#tmux split-window -t muxic -h 'zsh'
tmux select-pane -t muxic -D
tmux set -t muxic status off
tmux -2 attach-session -t muxic -d
