#!/bin/bash

track="$(mpc current)"
tname=$( echo $track | sed 's/.*\// /' ) #Just the basename
playlist=$( mpc lsplaylists | dmenu -l 9 -p "Add $tname to playlist:"  )

if [[ $playlist != "" ]]; then
	pwdpl=~/.mpd/playlists/$playlist.m3u
	isthere=$( grep -F "$track" $pwdpl -c )

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
fi
