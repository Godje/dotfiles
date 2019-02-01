#!/bin/bash

confirmation=$( echo -e 'yes\nno' | dmenu -p 'Exit i3-wm? ' );
if [ $confirmation == 'yes' ]; then
	i3-msg exit
else
	notify-send --urgency=low --expire-time=1300 "Exit aborted" ''
fi
