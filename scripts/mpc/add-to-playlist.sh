#!/bin/bash

track="$(mpc current -f %file%)" # full track name
tname=$( echo $track | sed 's/.*\// /' ) # just the basename
playlist=$( mpc lsplaylists | dmenu -l 9 -p "Add $tname to playlist:"  )
plexists=$( mpc lsplaylists | grep -F $playlist -c )

if [[ $playlist != "" ]] && [[ $plexists > 0 ]]; then
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
else
	confirmnew=$( echo -e "yes\nno" | dmenu -p "Create new playlist? " )
	if [ $confirmnew == 'yes' ]; then
		touch ~/.mpd/playlists/$playlist.m3u
		echo $track >> ~/.mpd/playlists/$playlist.m3u
		notify-send --urgency=low --expire-time=2350 "Playlist $playlist created" "with $tname as it's first track"
	fi
fi

mpc update
