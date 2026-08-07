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
HISTSIZE=10000
HISTFILESIZE=560000 # about 10 megabytes
HISTTIMEFORMAT='%F %T  '

PROMPT_COMMAND='history -a;'
alias himport="history -n;"

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
    xterm-color|*-256color|alacritty) color_prompt=yes;;
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
# cat ~/.cache/wal/sequences

# To add support for TTYs this line can be optionally added.
# source ~/.cache/wal/colors-tty.sh

mp3towav(){
	[[ $# -eq 0 ]] && { echo "mp3wav mp3file"; exit 1; }
	for i in "$@"
	do
		# create .wav file name
		local out="${i%/*}.wav"
		[[ -f "$i" ]] && { echo -n "Processing ${i}..."; mpg123 -w "${out}" "$i" &>/dev/null  && echo "done." || echo "failed."; }
	done	
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
		# if y passed in, or y answered, shut down, otherwise cancel shutdown
		if [[ "$2" =~ y.* ]]; then
			echo "shutting down"
			busy end
			poweroff
		else
			read -p "Check the busy. If done input 'y' for shutdown: " inputResult
			if [[ "$inputResult" =~ y.* ]]; then
				echo "shutting down"
				busy end
				poweroff
			else
				echo "Not shutting down."
			fi
		fi
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

# Optional query fzf
#
# usage:
# opt_picker <list command string> <fzf additional args> <query>
# third argument can usually be "$*" to forward user input
#
# example:
# opt_picker \
#	"echo -e '1 first\n2 second'"
#	"--with-nth 2" \
#	"$*"
function opt_picker(){
	local list=$(eval "$1")
	local query="${@:3}"
	local fzf_args="$2"
	local selected;
	local rc;
	if [[ -z "$query" ]]; then
		selected=$(echo "$list" | fzf $fzf_args)
		rc=$?
	else
		selected=$(echo "$list" | fzf --query "$query" $fzf_args --cycle --select-1 --exit-0)
		rc=$?
	fi
	echo "$selected"
	return $rc;
}

function gtc(){
	: "@help cd's into worktree directory based on branch name."
	popd 2>/dev/null
	local selected=$(opt_picker "git worktree list | tr -d '[]'" "--with-nth 3" "$*")
	if [[ $? -eq 0 ]]; then
		local path=$(echo $selected | awk '{print $1}')
		pushd "$path" # popd will return back to home
	fi
}

# git checkout branch
function gcheck() {
	local selected=$(opt_picker "git branch --list -a | cut -c3- | grep -v detached | awk '{print \$1}'")
	git checkout "$selected"
}

function smpd(){
	mpd ~/.config/mpd/mpd.conf
}

function ncmpcpp() {
	if [ $(ps aux | grep mpd -c) -gt 1 ]; then
		command ncmpcpp;
	else
		smpd
		command ncmpcpp;
	fi
}

function b (){
	local second;
	[[ -z "${@:2}" ]] && second="placeholder" || second="${@:2}"
	case "$1" in
		pdf) busy create "Code" "PDF Redactor" "${second}" ;;
		rest) busy create "Rest" "Rest" "Rest" ;;
		restr*) busy create Restroom Restroom Restroom ;;
		food) busy create Food Food "${second}" ;;
		misc) busy create Misc Misc Misc ;;
		mom) busy create "Mom" "Mom" "shenanigans" ;;
		end) busy end ;;
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
	yt-dlp "$1" --js-runtimes bun --format bestaudio --print "after_move:%(filepath,_filename|)q" --no-simulate > last_downloaded_file.txt 
	# Open nautilus with the file highlighted (with ' character trimmed)
	[ $? -eq 0 ] && nautilus --select "$(cat last_downloaded_file.txt | tail -c +2 | head -c -2)" &
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

nvim () {
	if [ -z "$1" ]; then
		if [ -e Session.vim ]; then
			command nvim -S Session.vim
		else
			command nvim
		fi
	else
		command nvim "$@"
	fi
}

declankify(){
	# Read stdin into a temporary file
	local tmpfile=$(mktemp)
	cat > "$tmpfile"

	# remove clanker signs
	sed -i "s/’/\'/g" "$tmpfile"
	sed -i "s/—/ - /g" "$tmpfile"

	# Output to clipboard (works on different platforms)
	if command -v xclip &>/dev/null; then
		xclip -sel clipboard < "$tmpfile"
	elif command -v pbcopy &>/dev/null; then
		pbcopy < "$tmpfile"
	elif command -v wl-copy &>/dev/null; then
		wl-copy < "$tmpfile"
	else
		echo "No clipboard tool found" >&2
	fi

	# Optionally print the result for confirmation
	cat "$tmpfile"

	rm "$tmpfile"
}

yq() {
	docker run --rm -i -v "${PWD}":/workdir mikefarah/yq "$@"
}

# Stolen here: https://www.stefaanlippens.net/pretty-csv.html
function pretty_csv {
	column -t -s, -n "$@" | less -F -S -X -K
}

function bulkrename {
	lsTemp=$(mktemp)
	resultCommand=$(mktemp)
	ls -d "$PWD"/* > "$lsTemp"
	$EDITOR "$lsTemp"
	while IFS= read -r pre && IFS= read -r post <&3; do
		printf 'mv "%s" "%s"\n' "$pre" "$post" >> "$resultCommand"
	done < <(ls) 3< "$lsTemp"

	cat "$resultCommand"
	read -p "Do you want to execute those mv commands? [y/N] " inputResult
	if [[ "$inputResult" =~ y.* ]]; then
		sh "$resultCommand"
	else
		echo "Action cancelled"
	fi
}

# claude env variables
export CLAUDE_AFK_TIMEOUT_MS=86400000
export CAVEMAN_DEFAULT_MODE="off"
export CAVEMAN_STATUSLINE_SAVINGS=0

function inside_tmux(){
	! [ -z $TMUX_PANE ]
}

function claude(){
	if inside_tmux; then
		command claude $*;
	else
		tmux list-sessions -F '#{session_name}' | grep -q "^ai$"
		local session_exists=$?
		if [ $session_exists -eq 0 ]; then
			tmux attach-session -d -t "ai" \; new-window -b -c "$(pwd)" "claude $*" \; attach
		else
			tmux new-session -d -s "ai" -c "$(pwd)" "claude $*"
		fi
	fi
}

function clave(){
	pushd "/tmp/"
	claude
	popd
}

function qlave(){
	pushd "/tmp/"
	claude --model haiku
	popd
}

function note(){
	nvim ~/note.md
}

claude-sync(){
	local parent="$HOME/.claude/"
	local dirs=(
		"projects/"
		"plans/"
		"agents/"
	)
	for dir in "${dirs[@]}"
	do
		case "$1" in
			push) rsync -avh --info=progress2 "$parent$dir" claude-sync-peer:$dir ;;
			pull) rsync -avh --info=progress2 claude-sync-peer:$dir "$parent$dir";;
			dry) rsync -avhn "$parent$dir" claude-sync-peer:$dir ;;
			*) echo "usage: claude-sync {push|pull|dry}"; return 1 ;;
		esac
	done
}

function gs(){
	git -c color.ui=always status
}
function wgs(){
	watch git -c color.ui=always status
}

function bamboo(){
	local temp=$(mktemp)
	cat "$DOTFILES/bamboo-wal.json" | sed "1a\"wallpaper\":\"$WALLPAPER\"," > $temp
	wal -f "$temp"
}

# mc: my cache
# user is expected to provide "$1". These functions don't check for empty's
export MC_CACHE_FOLDER="$HOME/.cache/my_bash_cache"
function _mc_ensure_cache_folder_exists(){
	[[ -d "$MC_CACHE_FOLDER" ]] || mkdir -p "$MC_CACHE_FOLDER"
}
# returns path to cache folder. Creates a cache folder if doesn't exist.
function _mc_getfolder(){
	_mc_ensure_cache_folder_exists
	local folder_name="$1"
	[[ -z "$folder_name" ]] && return 1;
	local cache_path="$MC_CACHE_FOLDER/$folder_name"
	mkdir -p "$cache_path"
	echo "$(cd "$cache_path" && pwd)"
}
# returns path for cache file. Creates a cache file if file doesn't exist.
function _mc_getfile(){
	_mc_ensure_cache_folder_exists
	local file_name="$1"
	[[ -z "$file_name" ]] && return 1;
	local cache_path="$MC_CACHE_FOLDER/$file_name"
	[[ -e "$cache_path" ]] || touch "$cache_path";
	[[ $? -eq 0 ]] && echo "$cache_path" || return 1;
}
# appends to cache file
function _mc_append(){
	local cache_file="$(_mc_getfile "$1")"
	local cache_input="${@:2}"
	# deduping
	local linenum=$(grep -Fnx "$cache_input" "$cache_file" | cut -d: -f1);
	if [[ -n "$linenum" ]]; then sed -i "${linenum}d" "$cache_file"; fi
	echo -e "$cache_input" >> "$cache_file"
}
# opt_picker reads from cache file
function _mc_opt_picker(){
	local cache_file="$(_mc_getfile "$1" || return)"
	local result=$(opt_picker "cat ${cache_file} | grep -v '^$'" "" "")
	case $? in
		0) echo "$result" ;;
		1|2|130) return 1 ;;
	esac
}
function mc_clear_cache(){
	local cache_file="$(_mc_getfile "mds_cache")"
	echo "" > $cache_file
}

# markdown show.
# example of _mc cache usage
# uses glow, fzf
function mds(){
	local file="${1:-$(_mc_opt_picker "mds_cache" || echo "")}"
	[[ -n "$file" ]] && glow -p -w $(( $COLUMNS - 5 )) "$file"
	[[ $? -eq 0 && -n "$1" ]] && _mc_append "mds_cache" "$(realpath "$1")"
}

# VI keymap
set -o vi
bind -m vi-insert "\C-l":clear-screen

# Aliases
alias ecfg="vim ~/.config/i3/config"
alias ebash="vim ~/.bashrc"
alias sbash="source ~/.bashrc"
alias evrc="vim ~/.vimrc"
alias vims="vim -S vimsession.vim"
alias vimm="nvim"
alias glog="git log --oneline -n 20"
alias killsteam="ps aux | grep steam | sed 's/\( \)\{1,\}/ /g' | cut -d' ' -f2 | xargs kill"
alias gs="git -c color.ui=always status"
alias wgs="watch git -c color.ui=always status"

which nvim >/dev/null && alias vim="nvim"

alias note="vim ~/note.md"
alias r="ranger" 
alias n=ncmpcpp
alias cd="z"
alias la="ls --color=no"
alias mux="tmuxinator"
alias rangre="ranger" #just because I always mistype
alias ftb="java -jar ~/Downloads/FTB_Launcher.jar";
alias cdqmk="cd ~/qmk_firmware/keyboards/lily58/keymaps/Godje/";
alias cddot="cd $DOTFILES";
alias bc="bc -l"
alias nvims="nvim -S Session.vim"
alias jellyfin="flatpak run com.github.iwalton3.jellyfin-media-player"
alias yta="yt-dlp --format bestaudio"
alias walpal="wal -i \"$WALLPAPER\""
alias ubuntu_codename="lsb_release -cs 2>/dev/null"
alias pdf="tmuxinator start pdf"

# TMUX shortcuts
alias tlist="tmux list-sessions"
alias tattach="tmux attach -t"
alias tnew="tmux new-session -t"
function tach(){
	if [[ -z "$1" ]]; then
		echo "usage: tach <session-name>. available sessions:"
		tmux list-sessions
	else
		tmux attach -t "$*"
	fi
}

# ANTRL4 setup 4.13.1
alias antlr4='java -Xmx500M -cp "/usr/local/lib/antlr-4.13.1-complete.jar:$CLASSPATH" org.antlr.v4.Tool'
alias grun='java -Xmx500M -cp "/usr/local/lib/antlr-4.13.1-complete.jar:$CLASSPATH" org.antlr.v4.gui.TestRig'

alias late="ssh -o ForwardAgent=no -o IdentitiesOnly=yes -i ~/.ssh/late_throwaway late.sh"

export CLASSPATH=".:/usr/local/lib/antlr-4.13.1-complete.jar:$CLASSPATH";

# EXPORTS
export EDITOR="nvim"
# PATH
[ -f "$HOME/.config/shell/path.sh" ] && . "$HOME/.config/shell/path.sh"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"

# bun
export BUN_INSTALL="$HOME/.bun"
path_prepend "$BUN_INSTALL/bin"

GPG_TTY=$(tty)
export GPG_TTY

# zoxide
eval "$(zoxide init bash)"

# direnv
eval "$(direnv hook bash)"

# cmake
export CMAKE_ROOT="~/Downloads/deb/cmake-4.1.1-linux-x86_64"
