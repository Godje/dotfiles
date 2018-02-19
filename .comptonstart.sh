#bin/sh

sleep 1
nvidia-settings --load-config-only
sleep 1
compton --shadow-exclude 'argb && _NET_WM_OPAQUE_REGION@:c' -b --config ~/.config/compton/compton.conf
