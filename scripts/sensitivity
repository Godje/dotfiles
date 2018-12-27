if [ "$SEARCH" = "Razer DeathAdder Chroma" ]; then 
	exit 1
fi

ids=$(xinput --list | awk -v search="$SEARCH" \
	'$0 ~ search {match($0, /id=[0-9]+/);\
	if (RSTART) \
		print substr($0, RSTART+3, RLENGTH-3)\
	}'\
	)

for i in $ids
do
	xinput set-prop $i 'libinput Accel Speed' -0.8
	xinput set-prop $i 'libinput Accel Speed Default' -0.8
	xinput set-prop $i 407 -0.8
	xinput set-prop $i 408 -0.8
done
