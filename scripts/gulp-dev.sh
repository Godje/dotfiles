#!/bin/bash

# This is my script to run my development environment immediately within TMUX.
# This script creates a TMUX session in which my development will happen.
# It runs gulp, vim, and ranger in three separate panes
# Script later runs commands and renames each window to the name I prefer or to the name I tell it to.


# basic vars
CWD=$(pwd)
SESSION_NAME="dev-env"

# setup
GULP_INFO=("gulp" "npm run start")
VIM_INFO=("vim" "vim -S vimsession.vim")
FILES_INFO=("files" "ranger")

# window setup function
function setup_window() { # arguments are passed from an array
	# getting an array
	arr=("$@")

	last_window=$(tmux list-windows -t $SESSION_NAME | tail -1)
	last_id=${last_window:0:1}
	next_id=$((last_id + 1))

	tmux new-window -t $SESSION_NAME:${next_id} -n "${arr[0]}"
	tmux select-window -t $SESSION_NAME:${next_id}
	tmux send-keys "${arr[1]}" C-m
	tmux rename-window -t $SESSION_NAME:${next_id} "${arr[0]}"
}

# getting the size of the terminal. Used for panes, but not needed here though
set -- $(stty size) 

tmux new-session -d -s $SESSION_NAME -x "$2" -y "$(($1 - 1))"

setup_window "${GULP_INFO[@]}"
setup_window "${VIM_INFO[@]}"
setup_window "${FILES_INFO[@]}"

tmux select-window -t $SESSION_NAME:0
tmux kill-window -t 0

tmux select-window -t $SESSION_NAME:2

tmux attach -t $SESSION_NAME
