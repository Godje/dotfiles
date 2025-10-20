# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

source ~/.bashvars


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]\n\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
(cat ~/.cache/wal/sequences &)

# Alternative (blocks terminal for 0-3ms)
cat ~/.cache/wal/sequences

# To add support for TTYs this line can be optionally added.
source ~/.cache/wal/colors-tty.sh

mp3towav(){
	[[ $# -eq 0 ]] && { echo "mp3wav mp3file"; exit 1; }
	for i in "$@"
	do
		# create .wav file name
		local out="${i%/*}.wav"
		[[ -f "$i" ]] && { echo -n "Processing ${i}..."; mpg123 -w "${out}" "$i" &>/dev/null  && echo "done." || echo "failed."; }
	done	
}



# TMUX shortcuts
tattach(){
	tmux attach -t $1
}
tlist(){
	tmux list-sessions
}
tnew(){
	tmux new-session -t $1
}

# Converting videos for DaVinci Resolve
videodnxhd(){
	ffmpeg -i $1 -c:v dnxhd -vf "scale=1920:1080,fps=25/1,format=yuv422p10" -b:v $2 -c:a pcm_s16le $3
}

# a meme
commit(){
	if [[ "$1" == "sepuku" ]]; then
		logout
	fi
	if [[ "$1" == "sudoku" ]]; then
		## ~/.config/i3/lock.sh
		sudo systemctl suspend
	fi
	if [[ "$1" == "lifent" ]]; then
		poweroff
	fi
	if [[ "$1" == "tensei" ]]; then
		poweroff --reboot
	fi
}
complete -W "sudoku sepuku lifent tensei" commit

# editing encrypted gpg file
encryptedit(){
	filename=$(basename $1 .gpg)
	gpg -d --quiet $1 | cat >> $filename 
	vim $filename 
	gpg -c $filename 
	rm $filename
}

# Other
mdpdf (){
	targetfile="/tmp/mdcss.css";
	importstring="@import url('https://fonts.googleapis.com/css?family=Roboto:400,400i,700,700i&display=swap&subset=cyrillic');"
	# downloading css
	curl https://gist.githubusercontent.com/tuzz/3331384/raw/fc0160dd7ea0b4a861533c4d6c232f56291796a3/github.css | sed 's/Helvetica/Roboto/' > $targetfile;
	# importing fonts
	echo "$importstring" >> $targetfile;

	md-to-pdf --stylesheet $targetfile $1
}

# fff cd on exit
f() {
	fff "$@"
	cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
}

function ccheck(){
	if [[ $PWD == *"rust-projects"* ]]; then
		cargo check;
		return;
	fi
	command ccheck;
}

function crun(){
	if [[ $PWD == *"rust-projects"* ]]; then
		cargo run;
		return;
	fi
	command crun;
}

function ffind(){
	find / -name "$1" 2>/dev/null
}


function buildCRBN(){
	WEST_LOCATION="/home/daniel/git/others/zmk/app"
	CFG_LOCATION="/home/daniel/git/crbn-keymap/config/"
	TMP_UF2=$(mktemp)

	cd $WEST_LOCATION
	west build -p -b nice_nano -- -DSHIELD=crbn -DZMK_CONFIG=$CFG_LOCATION
}

function flashCRBN(){
	WEST_LOCATION="/home/daniel/git/others/zmk/app"
	CFG_LOCATION="/home/daniel/git/crbn-keymap/config/"
	TMP_UF2=$(mktemp)

	cd $WEST_LOCATION
	west build -p -b nice_nano -- -DSHIELD=crbn -DZMK_CONFIG=$CFG_LOCATION
	cp /home/daniel/git/others/zmk/app/build/zephyr/zmk.uf2 /media/daniel/NICENANO/
}

function flashMUNLeft(){
	qmk flash -kb rgbkb/mun -km Godje -bl dfu-util-split-left
}
function flashMUNRight(){
	qmk flash -kb rgbkb/mun -km Godje -bl dfu-util-split-right
}

function restartWorkers() {
	sudo supervisorctl restart all;
}

function discordUpdate(){
	p=$(pwd)
	cd ~/Downloads/discord_deb/
	curl -Ls -o ~/Downloads/discord_deb/latest.deb -w %{url_effective} 'https://discord.com/api/download/stable?platform=linux&format=deb' | xclip -selection discord_url
	mv latest.deb $(basename $(xclip -selection discord_url -o))

	toInstall=$( find ~/Downloads/discord_deb/ -type f -exec stat -c '%Y %n' "{}" \; | sort -n | tail -n1 | cut -d ' ' -f2)
	sudo apt install "$toInstall"

	cd "$p"
}

function winekill() {
	pid=`ps aux | awk '/C:/{print $2};'`;
	kill $pid;
}
function vkstart() {
	wine ~/Downloads/VKSetup.exe 2>/dev/null
}

function vkkill() {
	winekill
}

function gcheck() {
	if [ $(git branch --show-current | grep "$1" -c) -gt 0 ]; then
		echo "This branch already selected";
	elif [ $(git branch --list | grep "$1" -c) -eq 0 ]; then
		echo "The branch doesn't exist";
	else
		git checkout $(git branch --list | grep "$1")
	fi
}

function smpd(){
	mpd ~/.config/mpd/mpd.conf
}

function ncmpcpp() {
	if [ $(ps aux | grep mpd -c) -gt 1]; then
		command ncmpcpp;
	else
		smpd
		command ncmpcpp;
	fi
}

function b (){
	if [ -e "$1" ]; then
		busy print 1;
	fi
	case "$1" in
	    e) vim $BUSYFILE;;
			r) busy resume;;
			p) busy print;;
	esac
}

# function designed for my school C++ data structures class
function gppt() {
	if [ $# -eq 0 ]; then
		clear && figlet "output" && g++ -std=c++14 *.cpp -o a.out;
		./a.out 1> result.txt 2> /dev/null;
		figlet "result" && ./a.out
		return;
	fi

	clear && figlet "output" && g++ -std=c++14 "$1" -o a.out

	if [ $? -gt 0 ]; then
		e_filename="error_output.txt"
		figlet "error";
		g++ test.cpp -o a.out 2> $e_filename
		echo "Error length:" $(wc -l $e_filename);
		rm $e_filename;
	else
		./a.out
	fi
}

bc-dlp () {
yt-dlp --format bestaudio "$1" -o "%(artists.0)s/%(album)s/%(track_number)s. %(title)s [%(album)s, %(release_year)s][%(id)s].%(ext)s"
}

mom-dlp () {
	# Download the video file, save the last downloaded filename into a file
	yt-dlp "$1" --format bestaudio --print "after_move:%(filepath,_filename|)q" --no-simulate > last_downloaded_file.txt 
	# Open nautilus with the file highlighted (with ' character trimmed)
	nautilus --select "$(cat last_downloaded_file.txt | tail -c +2 | head -c -2)" &
}

primtoclip () {
	# WIP, this poop doesn't work I think
	xclip -selection primary -o | xclip -selection clipboard
}
# MIT from https://stackoverflow.com/a/58598185/5410502
# capture the output of a command so it can be retrieved with ret
cap () { tee /tmp/capture.out; }
# return the output of the most recent command that was captured by cap
ret () { cat /tmp/capture.out; }

# VI keymap
set -o vi
bind -m vi-insert "\C-l":clear-screen

# Aliases (might move to .bash_aliases in the future)
alias ecfg="vim ~/.config/i3/config"
alias ebash="vim ~/.bashrc"
alias sbash="source ~/.bashrc"
alias evrc="vim ~/.vimrc"
alias vims="vim -S vimsession.vim"
alias vimm="nvim"

which nvim >/dev/null && alias vim="nvim"

alias vimnote="vim ~/note.md"
alias r="ranger" 
alias n=ncmpcpp
alias cd="z"
alias la="ls --color=no"
alias mux="tmuxinator"
alias rangre="ranger" #just because I always mistype
alias ftb="java -jar ~/Downloads/FTB_Launcher.jar";
alias cdqmk="cd ~/qmk_firmware/keyboards/lily58/keymaps/Godje/";
alias cddot="cd $DOTFILES";
alias cdschool="cd \"$SCHOOLDIR\"";
alias lilfl="$DOTFILES/lily58_godje/scripts/flash-layout.sh";
alias javac="javac --release 11"
alias bc="bc -l"
alias nvims="nvim -S Session.vim"
alias jellyfin="flatpak run com.github.iwalton3.jellyfin-media-player"

alias screenkey="/media/daniel/therest/linux/builds/screenkey/screenkey"

# ANTRL4 setup 4.13.1
alias antlr4='java -Xmx500M -cp "/usr/local/lib/antlr-4.13.1-complete.jar:$CLASSPATH" org.antlr.v4.Tool'
alias grun='java -Xmx500M -cp "/usr/local/lib/antlr-4.13.1-complete.jar:$CLASSPATH" org.antlr.v4.gui.TestRig'

export CLASSPATH=".:/usr/local/lib/antlr-4.13.1-complete.jar:$CLASSPATH";

# EXPORTS
export EDITOR="nvim"
export PATH="$PATH:/home/daniel/.nimble/bin:/home/daniel/.local/bin:/home/daniel/.local/bin/scripts:/home/daniel/git/busy.sh:/home/daniel/.config/composer/vendor/bin:/opt/nvim-linux64/bin:/home/daniel/.cargo/bin"

GPG_TTY=$(tty)
export GPG_TTY

# zoxide
eval "$(zoxide init bash)"

# cmake
export CMAKE_ROOT="~/Downloads/deb/cmake-4.1.1-linux-x86_64"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"
