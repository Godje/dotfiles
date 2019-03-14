#!/bin/bash
# Post install script for clean Ubuntu installation

PRE=" > "

function installSoftware(){
	apt update && apt upgrade -y

	apt install -y	\
		vim \
		vim-gtk	\
		python3	\
		python3-pip	\
		tmux	\
		screen	\
		compton	\
		i3	\
		i3blocks	\
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
		i3lock	\
		ncmpcpp	\
		mpd	\
		mpc	\
		openjdk-8-jre	\
		vlc	\
		mupdf	\
		dunst	\
		net-tools


	# Installing WPS manually lol. Good thing they got a link
	currDir=$(pwd)
	mkdir -p ~/Documents/temp/ && cd ~/Documents/temp
	curl -O http://kdl.cc.ksosoft.com/wps-community/download/6757/wps-office_10.1.0.6757_amd64.deb
	apt install ./wps-office_10.1.0.6757_amd64.deb 
	cd $currDir

	# wal
	pip3 install pywal

	# Switching to URxvt
	update-alternatives --config x-terminal-emulator

	# NVIDIA drivers
	add-apt-repository ppa:graphics-drivers
	apt update
	apt install nvidia-390

	echo "$PRE"
	echo "$PRE Don't forget to set dunst as default notification manager (manual labor)"
	echo "$PRE"
}

function createSymlinks(){
	function csym(){
		echo "Linking $1"
		ln -s -f $1 $2
		result=$( echo $? )
		if [[ $result == 0 ]]; then
			echo "Success"
		else
			echo "$result"
		fi
	}

	while true; do
		read -p "$PRE Please type a directory to your repository: " repdirectory
		if [[ -d $repdirectory ]]; then
			echo "$PRE Located directory"
			echo "$PRE Linking files"

			csym $repdirectory/.bashrc ~/.bashrc
			csym $repdirectory/.Xresources ~/.Xresources
			csym $repdirectory/.vim ~/.vim
			csym $repdirectory/.vimrc ~/.vimrc
			csym $repdirectory/.comptonstart.sh ~/.comptonstart.sh

			for conf in $repdirectory/.config/*
			do
				bname=$( basename $conf )
				csym "$conf" ~/.config/$bname
			done

			echo "$PRE Sourcing the .bashrc"
			source ~/.bashrc
echo "$PRE Mergin .Xresources"
			xrdb -merge ~/.Xresources
		fi
		break;
	done
}

# This thing is not tested what the frick. 
function cloneRepository(){
	read -p "$PRE The link to the repository: " replink
	requestResult=$( curl -I $replink | head -n 1 | cut -d$' ' -f2 )
	if [[ $requestResult == 404 ]]; then
		echo "$PRE Bad link. 404"
	elif [[ $requestResult == 200 ]]; then
		read -p "$PRE Good link. 200. Where do you want clone the repo to?" repwhere
		git clone $replink $repwhere
	else
		echo "$PRE $requestResult"
	fi

	echo "execute the script again, say Yes on \" Did you clone repo \" question"
}


# The prompts part

if [[ $EUID -ne 0 ]]; then
   	echo "$PRE This script must be run as root" 
   	exit 1
else
	echo "$PRE Make sure you have modified the script to your needs."
	echo "$PRE This script has a list of software that Godje made."

	# Prompt for installing software
	while true; do
		read -p "$PRE Have you installed software/packages yet? [y/n] " didinstall
		case $didinstall in
			[Nn]*	) installSoftware; break;;
			[Yy]*	) break;;
			*	)	echo	"Please answer yes or no."
		esac
	done

	# Prompt for repositories
	while true; do
		read -p "$PRE Have you clones your repository yet? [y/n] " repois
		case $repois in
			[Yy]*	) createSymlinks; break;;
			[Nn]*	) cloneRepository; break;;
			*	)	echo	"Please answer yes or no."
		esac
	done
fi
