#!/bin/bash

#  _   _  _ __ __      __ _ __  __ _  _ __     ___ | |__
# | | | || '_ \\ \ /\ / /| '__|/ _` || '_ \   / __|| '_ \
# | |_| || | | |\ V  V / | |  | (_| || |_) |_ \__ \| | | |
#  \__,_||_| |_| \_/\_/  |_|   \__,_|| .__/(_)|___/|_| |_|
#                                    |_|
#

## TODO: Maybe there is some minimal fzf alternative that would replace this mess of "select" actions

PRE=">"

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
	echo "   v - install VSCode"
	#echo "   R - install Rust software packages"
}

say(){
	echo -e $PRE "$1"
}


# Option Functions

## Link Files
linkFiles(){
	if [[ -z "${DOTFILES}" ]]; then
		echo "$PRE DOTFILES is not set. Please set environment variable DOTFILES to the dotfiles directory"
		exit
	fi

	cd $DOTFILES
	stow --dir="$DOTFILES" --target="$HOME" --stow .
	if [[ "$?" -eq 0 ]]; then
		echo "$PRE stowing complete"
	else
		echo "$PRE stowing failed"
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
		python3 \
		ripgrep \
		pipx \
		tmux \
		suckless-tools	\
		curl \
		stow \
		firefox	\
		i3blocks \
		wget \
		pandoc \
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
		xclip \
		thunar \
		dolphin \
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
	# installation from source according to neovim's BUILD.md

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

	/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2025.12.14_all.deb keyring.deb SHA256:2c816fbd12ea4d84811818aed0ce3a5da589be1afa30833eb32abc1e4fe6349e
	sudo apt install ./keyring.deb
	echo "deb [signed-by=/usr/share/keyrings/sur5r-keyring.gpg] http://debian.sur5r.net/i3/ $(grep '^VERSION_CODENAME=' /etc/os-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list

	sudo apt update
	sudo apt install i3

	cd $localfolder
}


installVSCode(){
	tempfolder=$(mktemp -d)
	localfolder=$(pwd)

	cd $tempfolder

	wget --content-disposition "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
	sudo apt install ./code*.deb

	cd $localfolder
}

installPipPackages(){
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
	wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/refs/heads/master/install.sh | bash
}

installAlacritty(){
	sudo apt install cmake g++ pkg-config libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
	cargo install alacritty
	sudo update-alternatives --set x-terminal-emulator $HOME/.cargo/bin/alacritty 
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
	4) installPipPackages
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
	v) installVSCode
		;;
	a) installAlacritty
		;;
esac
