#!/bin/bash

CWD=$(pwd)
SESSION_NAME='mcss'

# Create a new session, -d means detached itself
set -- $(stty size)

tmux new-session -d -s $SESSION_NAME -x "$2" -y "$(($1 - 1))"

tmux new-window -t $SESSION_NAME:1 -n "server"
tmux new-window -t $SESSION_NAME:2 -n "client"

tmux select-window -t $SESSION_NAME:1
tmux send-keys "cd /media/daniel/therest/rc/ && ./start.sh" C-m
tmux rename-window -t $SESSION_NAME:1 "server"

tmux select-window -t $SESSION_NAME:2
tmux send-keys "java -jar ~/Downloads/Minecraft.jar" C-m
tmux rename-window -t $SESSION_NAME:2 "client"

tmux kill-window -t 0
tmux attach -t $SESSION_NAME
