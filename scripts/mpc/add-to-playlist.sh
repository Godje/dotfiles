#!/bin/bash
#
# Author: Daniel Mayovskiy
#
# Description: 
# This script prompts you to which playlist the current track played through mpd should b
# added. If the playlist is not in the list, and you type in the name of the new 
# playlist it will ask you if you want to create the playlist by that name
#
# Dependencies:
# dmenu, mpc, mpd, sed
# dunst as notify-send (optional)
#
# Specifics:
# Do not put the last dash in the playlists directory in $plDirectory

plDirectory=~/.mpd/playlists
track="$(mpc current -f %file%)" # full track name
tname=$( echo $track | sed 's/.*\// /' ) # just the basename
playlist=$( mpc lsplaylists | dmenu -l 9 -p "Add $tname to playlist:"  ) # getting the name of the playlist
plexists=$( mpc lsplaylists | grep -F $playlist -c ) # checking if the playlist exists

if [[ $playlist != "" ]] && [[ $plexists > 0 ]]; then
	pwdpl=$plDirectory/$playlist.m3u
	isthere=$( grep -F "$track" $pwdpl -c ) # checking to see if the file is already in the playlist.

	if [[ $isthere == 0 ]]; then
		echo $track >> $pwdpl
		notify-send --urgency=low --expire-time=2350 "Playlist $playlist modified" "$tname appended"
	else
		confirm_delete=$( echo -e "yes\nno" | dmenu -p "Delete $tname from the playlist?" )
		if [[ $confirm_delete == "yes"  ]]; then
			notify-send --urgency=low --expire-time=2350 "Playlist $playlist modified" "$tname removed"
			dchar="d"
			sed -i "$isthere$dchar" $pwdpl
		fi
	fi
else
	confirmnew=$( echo -e "yes\nno" | dmenu -p "Create new playlist? " )
	if [ $confirmnew == 'yes' ]; then
		touch $plDirectory/$playlist.m3u
		echo $track >> $plDirectory/$playlist.m3u
		notify-send --urgency=low --expire-time=2350 "Playlist $playlist created" "with $tname as it's first track"
	fi
fi

mpc update
