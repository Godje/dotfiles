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
	echo "   1 - link the dotfiles"
	echo "   2 - install the software"
	echo "   3 - install i3 and i3-gaps (!INCOMPLETE)"
	echo "   4 - install a bunch of pip packages (why is this not part of option 2?)"
	echo "   5 - install Vim Submodules"
	echo "   6 - install NVM"
}

say(){
	echo -e $PRE "$1"
}


# Option Functions

## Link Files
linkFiles(){
	echo "This feature isn't implemented yet"
	exit # remove this once done with the script writing

	if [[ -z "${DOTFILES}" ]]; then
		echo "DOTFILES is not set. Please set environment variable DOTFILES to the dotfiles directory"
		exit
	fi

	cd $DOTFILES
	stow --dir="$DOTFILES" --target="$HOME" --stow .
	if [[ $? -e 0]]; then
		echo "stowing complete"
	else
		echo "stowing failed"
	fi
	cd -

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
		imagemagick	\
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

	# TODO: Install zoxide, tmuxinator, ruby

	# Removing the "socket taken" issue
	sudo service mpd stop
	sudo systemctl disable mpd.service
	sudo systemctl disable mpd.socket
	sudo systemctl stop mpd.socket
}

# Installing i3-gaps manually
installI3(){
	echo "$PRE This is a legacy installation script (before i3-gaps was merged into main). Please update to use PPA, or execute this function in unwrap.sh manually. Exiting the script".
	exit

	# TODO: Rewrite this to use the PPA with the up to date i3-gaps that is already in the main branch

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
	pip3 install wpm
}

installVimSubmodules(){
	cd $DOTFILES;

	git submodule init;
	git submodule update;
}

installNVM(){
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/refs/heads/master/install.sh | bash
	wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/refs/heads/master/install.sh | bash
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
	5) installVimSubmodules
		;;
	6) installNVM
		;;
esac
