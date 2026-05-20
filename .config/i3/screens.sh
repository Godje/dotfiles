#!/bin/bash

COUNT=$(xrandr -q | grep ' connected' -c)

if [[ "$COUNT" -gt 1 ]]; then
	echo "two screens"
	sh ~/.screenlayout/default.sh
else
	sh ~/.screenlayout/default-single-screen.sh
fi
