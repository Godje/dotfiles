#!/bin/bash
#
# Author:
# Daniel Mayovskiy
#
# Dependencies:
# dmenu, mpc, mpd
#
# Description:
# Lists the playlists that you have available in a dmenu, and oyu just pick the one you want to play
# It will crop the playlists that is currently playing (aka, remove everything except current song)
# and will load the playlist you selected. 

playlist=$( mpc lsplaylists | dmenu -l 9 -p "Play playlist: " )

if [[ "$playlist" != "" ]]; then
	mpd stop
	mpc clear
	mpc load $playlist > /dev/null
	mpc play
	notify-send --urgency=low --expire-time=2000 "Playlist loaded" "Playlist: $playlist"
fi
