#!/bin/bash

playlist=$( mpc lsplaylists | dmenu -l 9 -p "Play playlist: " )

if [[ "$playlist" != "" ]]; then
	mpc crop
	load_output=""
	mpc load $playlist > /dev/null
	notify-send --urgency=low --expire-time=2000 "Playlist loaded" "Playlist: $playlist"
fi
