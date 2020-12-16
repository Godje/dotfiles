#!/bin/bash

#  _   _  _ __ __      __ _ __  __ _  _ __     ___ | |__
# | | | || '_ \\ \ /\ / /| '__|/ _` || '_ \   / __|| '_ \
# | |_| || | | |\ V  V / | |  | (_| || |_) |_ \__ \| | | |
#  \__,_||_| |_| \_/\_/  |_|   \__,_|| .__/(_)|___/|_| |_|
#                                    |_|
#
# This is basically an improvement over the dookie script I had before. Here you can just one thing or another and
# there is less manual work. Hopefully.

PRE=">"

# Choices:
# 1 - link the dotfiles
# 2 - install the software
# 3 - install i3 and i3-gaps
# 4 - install python libraries


displayBanner(){
	echo "Godje's Dotfile unwrapping script";
	echo "don't forget to set the \$DOTFILES variable"
}

displayOptions(){
	echo "Actions"
	echo "   1 - link the dotfiles (this thing literally never works)"
	echo "   2 - install the software"
	echo "   3 - install i3 and i3-gaps"
	echo "   4 - install python libraries"
	echo "   5 - install youtube-dl"
	echo "   6 - install Vim Submodules"
}

say(){
	echo -e $PRE "$1"
}


# Option Functions

## Link Files
## This thing still doesn't work properly. I mean how do you even symlink directories, for some reason it just doesn't work
linkFiles(){
	csym(){
		echo "Linking $1"
		ln -s -f $1 $2
		result=$( echo $? )
		if [[ $result == 0 ]]; then
			echo "Success"
		else
			echo "$result"
		fi
	}

	dotfiledir=$(pwd);

	csym $dotfiledir/.bashrc ~/.bashrc
	csym $dotfiledir/.Xresources ~/.Xresources
	csym $dotfiledir/.vim ~/.vim
	csym $dotfiledir/.vimrc ~/.vimrc
	csym $dotfiledir/.comptonstart.sh ~/.comptonstart.sh
	csym $dotfiledir/scripts ~/Documents/scripts
	csym $dotfiledir/devscripts ~/Documents/devscripts

	for conf in $repdirectory/.config/*
	do
		bname=$( basename $conf )
		csym "$conf" ~/.config/$bname
	done

	echo "$PRE Sourcing the .bashrc"
	source ~/.bashrc
	echo "$PRE Merging .Xresources"
	xrdb -merge ~/.Xresources
}

## Installing software from repos
installSoftware(){
	sudo apt update && sudo apt upgrade -y

	sudo apt install -y	\
		vim	\
		ranger	\
		vim-gtk	\
		python3	\
		python3-pip	\
		tmux	\
		screen	\
		compton	\
		dmenu	\
		rxvt-unicode	\
		rxvt-unicode-256color	\
		curl	\
		firefox	\
		steam	\
		arandr	\
		feh	\
		neofetch	\
		gdebi	\
		gparted	\
		krita	\
		qutebrowser	\
		scrot	\
		ncmpcpp	\
		mpd	\
		mpc	\
		openjdk-8-jre	\
		vlc	\
		mupdf	\
		dunst	\
		net-tools	\
		deluge	\
		xclip	\
		thunar \
		mpv \
		sxiv

	# Switching default terminal to URxvt
	rxvtLocation=$(which urxvt);
	sudo update-alternatives --set x-terminal-emulator $rxvtLocation

	# Removing the "socket taken" issue
	sudo service mpd stop
	sudo systemctl disable mpd.service
	sudo systemctl disable mpd.socket
	sudo systemctl stop mpd.socket
}

# Installing i3-gaps manually
installI3(){
	sudo apt update;
	
	sudo apt install -y	\
		i3	\
		i3lock	\
		i3blocks	\
		libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
		libxcb-util0-dev libxcb-icccm4-dev libyajl-dev \
		libstartup-notification0-dev libxcb-randr0-dev \
		libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
		libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
		autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev \
		meson ninja-build

	tempfolder=$(mktemp -d)
	localfolder=$(pwd)

	# Regular build from source installation of i3-gaps
	cd $tempfolder

	git clone https://www.github.com/Airblader/i3 i3-gaps
	cd i3-gaps

	mkdir -p build && cd build
	meson ..
	ninja
	sudo meson install

	cd $localfolder
}

installPython(){
	pip3 install pywal
	pip3 install BeautifulSoup4
	pip3 install tmuxp
	pip3 install wpm
}

installYoutubeDL(){ 
	# official instructions on the website.
	sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
	sudo chmod a+rx /usr/local/bin/youtube-dl
	# this installs python2 for this thing to work.
	sudo apt install python
}

installVimSubmodules(){
	cd $DOTFILES;

	git submodule init;
	git submodule update;
}

# Displaying the options and executing the right function
displayOptions

read -p "Select one option: " selected

case $selected in
	1) linkFiles
		;;
	2) installSoftware
		;;
	3) installI3
		;;
	4) installPython
		;;
	5) installYoutubeDL
		;;
	6) installVimSubmodules
		;;
esac
