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
	echo "   2 - install software (that is available in Ubuntu repo)"
	echo "   3 - install i3 and i3-gaps (Ubuntu ppa)"
	echo "   4 - install a bunch of pip packages"
	echo "   5 - install dotfile submodules"
	echo "   6 - install NVM"
	echo "   s - install Steam"
	echo "   r - install Rustup"
	echo "   n - install neovim"
	#echo "   R - install Rust software packages"
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
	if [[ "$?" -eq 0 ]]; then
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
installRepoSoftware(){
	sudo apt update && sudo apt upgrade -y

	sudo apt install \
		vim	\
		imagemagick	\
		python3	\
		python3-pip	\
		tmux \
		suckless-tools	\
		curl \
		firefox	\
		i3blocks \
		wget \
		arandr \
		feh	\
		neofetch	\
		gparted	\
		krita	\
		qutebrowser	\
		scrot	\
		ncmpcpp	\
		mpc	\
		mpd	\
		mpv \
		vlc	\
		mupdf	\
		dunst	\
		net-tools	\
		deluge \
		xclip	\
		thunar \
		sxiv

	# TODO: Install zoxide, tmuxinator, ruby, alacritty, nvim

	# Removing the "socket taken" issue
	# sudo service mpd stop
	# sudo systemctl disable mpd.service
	# sudo systemctl disable mpd.socket
	# sudo systemctl stop mpd.socket
}

installSteam(){
	tempfolder=$(mktemp -d)
	localfolder=$(pwd)

	cd $tempfolder
	wget https://cdn.fastly.steamstatic.com/client/installer/steam.deb
	sudo apt install ./steam.deb

	cd $localfolder
}

installRust(){
	tempfolder=$(mktemp -d)
	localfolder=$(pwd)

	cd $tempfolder

	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

	cd $localfolder
}

installNeovim(){
	tempfolder=$(mktemp -d)
	localfolder=$(pwd)

	cd $tempfolder
	sudo apt install ninja-build gettext cmake curl build-essential git
	git clone https://github.com/neovim/neovim
	cd neovim
	git checkout stable
	cmake -S cmake.deps -B .deps -G Ninja -D CMAKE_BUILD_TYPE=Release
	cmake --build .deps
	make CMAKE_BUILD_TYPE=Release
	sudo make install

	cd $localfolder
}

# Installing i3-gaps manually
installI3(){
	tempfolder=$(mktemp -d)
	localfolder=$(pwd)

	cd $tempfolder

	/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2025.03.09_all.deb keyring.deb SHA256:2c2601e6053d5c68c2c60bcd088fa9797acec5f285151d46de9c830aaba6173c
	sudo apt install ./keyring.deb
	echo "deb [signed-by=/usr/share/keyrings/sur5r-keyring.gpg] http://debian.sur5r.net/i3/ $(grep '^VERSION_CODENAME=' /etc/os-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list

	sudo apt update
	sudo apt install i3

	cd $localfolder
}


installPython(){
	pipx install pywal --force
	pipx install wpm --force
	pipx install ranger-fm --force
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
	2) installRepoSoftware
		;;
	3) installI3
		;;
	4) installPython
		;;
	5) installVimSubmodules
		;;
	6) installNVM
		;;
	s) installSteam
		;;
	r) installRust
		;;
	n) installNeovim
		;;
esac
