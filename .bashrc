## Daniel's wonderful .bashrc

## INITIAL SETUP
source ~/.bashvars # variables I don't want to commit to git

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# VI keymap
set -o vi
bind -m vi-insert "\C-l":clear-screen

shopt -s checkwinsize

## HISTORY ##
# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=560000 # about 10 megabytes
HISTTIMEFORMAT='%F %T  '
HISTCONTROL=ignoreboth # don't put duplicate lines or lines starting with space in the history.

PROMPT_COMMAND='history -a;'
alias himport="history -n;"

# set variable identifying the chroot you work in (used in the PS1)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color|*-256color|alacritty) color_prompt=yes;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    export LESS="-R -F -X"
fi

# enable programmable completion features
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
[[ -t 1 ]] && (cat ~/.cache/wal/sequences &) >/dev/null

## UTILS ##

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

function is_number(){
	echo "$1" | grep -q "^[0-9]\+$"
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

# MIT from https://stackoverflow.com/a/58598185/5410502
# capture the output of a command so it can be retrieved with ret
cap () { tee /tmp/capture.out; }
# return the output of the most recent command that was captured by cap
ret () { cat /tmp/capture.out; }

function inside_tmux(){
	! [ -z $TMUX_PANE ]
}

function get_ps1(){
	# -- PS1 --
	# - nesting indicator
	if [ -n "$TMUX" ]; then _nest_base=2; else _nest_base=1; fi
	NEST_DEPTH=$(( SHLVL - _nest_base ))
	[ "$NEST_DEPTH" -lt 0 ] && NEST_DEPTH=0
	_np=$'\001'
	_npx=$'\002'
	_e=$'\033'
	[ -n "$RANGER_LEVEL" ] && ranger_nest_text="${_np}${_e}[38;5;5m${_npx}R${RANGER_LEVEL} "
	[ $NEST_DEPTH -gt 0 ] && bash_nest_text="${_np}${_e}[38;5;3m${_npx}B${NEST_DEPTH} "
	
	# - color check
	if [ "$color_prompt" = yes ]; then
		PS1='${debian_chroot:+($debian_chroot)}${ranger_nest_text}${bash_nest_text}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]\n\$ '
	else
		PS1='${debian_chroot:+($debian_chroot)}${ranger_nest_text}${bash_nest_text}\u@\h:\w\$ '
	fi
	unset color_prompt force_color_prompt _np _npx _e _nest_base
	echo "$PS1"
	# --
}
PS1=$(get_ps1)

function phelp(){
	type "$1" | grep '^\W*:'
}

function clean_empty(){
	: "removes empty lines from stdin"
	: "usage: cat text | clean_empty"
	sed '/^[[:space:]]*$/d'
}

# To add support for TTYs this line can be optionally added.
# source ~/.cache/wal/colors-tty.sh

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

function gd(){
	[ -z "$1" ] && git diff || git diff "$1"
}
function _gd_complete(){
	# the whole lowering thing is to for it to match case insensitive.
	# Doing the `set nocaseglob` doesn't work, so string replacement with
	# COMPREPLY being done without compgen was the only way to go
	COMPREPLY=()
	local cur="${COMP_WORDS[COMP_CWORD]}"
	local candidates=$(git status -s | cut -b4-)

	if [[ "$cur" == *[*?[]* ]]; then
		# match against glob
		for file in $candidates; do
			if [[ "$file" == $cur ]]; then
				COMPREPLY+=("$file")
			fi
		done
	else
		# match against prefix (case insensitive)
		while read -r file; do
			local cur_lower=$(echo "$cur" | tr '[:upper:]' '[:lower:]')
			if [[ $(echo "$file" | tr '[:upper:]' '[:lower:]') == "$cur_lower"* ]]; then
				COMPREPLY+=("$file")
			fi
		done <<< "$candidates"
	fi
}
complete -F _gd_complete gd

## GIT FUNCTIONS ##
function gtc(){
	: "cd's into worktree directory based on branch name."
	local selected=$(opt_picker "git worktree list | tr -d '[]'" "--with-nth 3" "$*")
	if [[ $? -eq 0 ]]; then
		local path=$(echo $selected | awk '{print $1}')
		cd "$path"
	fi
}
function glog(){
	: "usage: glog"
	: "       glog 1"
	: "       glog branch_name"
	: "       glog 1 branch_name"
	local count;
	local branch;
	if is_number "$1"; then
		count="${1:-15}";
		branch="${2:-HEAD}"
	else
		count=15;
		branch=$1;
	fi
	git log --oneline -n $count $branch
}
function gcheck() {
	local selected=$(opt_picker "git branch --list -a | cut -c3- | grep -v detached | awk '{print \$1}'" "--height=~100%" "$*")
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

function b(){
	local second;
	[[ -z "${@:2}" ]] && second="placeholder" || second="${@:2}"
	case "$1" in
		a) busy create "${second}" "${second}" "${second}" ;;
		pdf) busy create "Ship" "PDF Redactor" "${second}" ;;
		rest) busy create "Rest" "Rest" "Rest" ;;
		restr*) busy create Restroom Restroom Restroom ;;
		food) busy create Food Food "${second}" ;;
		misc) busy create Misc Misc "${second}" ;;
		mom) busy create Mom Mom "${second}" ;;
	end) busy end ;;
	e) nvim $BUSYFILE;;
	r) busy resume;;
	p) busy print;;
esac
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
		sh "$resultCommand" 2> >(grep -v "^mv.*are the same.*">&2)
	else
		echo "Action cancelled"
	fi
}

# claude env variables
export CLAUDE_AFK_TIMEOUT_MS=86400000
export CAVEMAN_DEFAULT_MODE="off"
export CAVEMAN_STATUSLINE_SAVINGS=0


function claude(){
	if [ $# -gt 2 ]; then
		command claude "$@";
		return;
	fi
	if [ -n "$NOCAVE" ]; then export CAVEMAN_DEFAULT_MODE="off"; fi
	if [ -n "$CAVE" ]; then export CAVEMAN_DEFAULT_MODE="lite"; fi
	if inside_tmux; then
		command claude "$@";
	else
		local session_count=$(tmux list-sessions -F '#{session_name}' | grep '^ai_' -c)
		local suffix=${CLAUDE_SESSION_SUFFIX:-''}
		local session_name="ai_""$suffix""_""$session_count"
		tmux new-session -s "$session_name" -c "$(pwd)" "claude $*" \; attach
	fi
}

function slave(){
	pushd "/tmp"
	CLAUDE_SESSION_SUFFIX=slave claude --model sonnet "$@";
	popd
}
function clave(){
	pushd "/tmp/"
	CLAUDE_SESSION_SUFFIX=clave claude --model opus "$@";
	popd
}

function qlave(){
	pushd "/tmp/"
	CLAUDE_SESSION_SUFFIX=qlave claude --model haiku "$@";
	popd
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

function bamboo(){
	local temp=$(mktemp)
	cat "$DOTFILES/bamboo-wal.json" | sed "1a\"wallpaper\":\"$WALLPAPER\"," > $temp
	wal -f "$temp"
}

# markdown show.
# example of _mc cache usage
# uses glow, fzf
function mds(){
	local file="${1:-$(_mc_opt_picker "mds_cache" || echo "")}"
	[[ -n "$file" ]] && glow -p -w $(( $COLUMNS - 5 )) "$file"
	[[ $? -eq 0 && -n "$1" ]] && _mc_append "mds_cache" "$(realpath "$1")"
}

# CD modifications
alias cds="tail /tmp/cd_history_$$ | tac | cat -n | tac"
function cd(){
	local p="$(pwd)"
	z "$@" && echo "$p" >> /tmp/cd_history_$$;
}
function ucd(){
	# TODO: no consecutive duplicates allowed
	local input="$1"
	local stack_file="/tmp/cd_history_$$";
	local stack_size=$(wc -l "$stack_file" | cut -d' ' -f1)
	local num_stack=$(tac "/tmp/cd_history_$$" | cat -n | sed 's/^[[:space:]]*//')
	local steps;
	if [ -z "$input" ]; then
		steps=1
	elif (( input < stack_size )); then
		steps=$input
	else
		steps=$stack_size
	fi

	[ -f "$stack_file" ] || return;
	local cd_target=$(echo "$num_stack" | grep "^\<$steps\>" | cut -f2)
	local cd_success="";
	if [ -n "$cd_target" ]; then
		# cd below gets replaced with the aliased "pwd >> stack_file" -----.
		cd "$cd_target" && cd_success=true                                 #
	else return; fi                                                            #
                                                                                   #
	if [ $cd_success ]; then                                                   #
		sed -i '$d' "$stack_file" # ... so the *just* added line needs  <--·
		                          # to be removed, not just the cd target 
		local temp=$(mktemp)
		tac "$stack_file" | sed "1,${steps}d" | tac > $temp && mv $temp "/tmp/cd_history_$$"
	fi

}
function _ucd_update_prompt(){
	local _np=$'\001'
	local _npx=$'\002'
	local _e=$'\033'
	local prefix="";
	local number=$(test -n "$TMUX" && wc -l /tmp/cd_history_$$ 2>/dev/null | cut -d' ' -f1)
	[ -n "$number" ] && [ $number -gt 0 ] && prefix="${_np}${_e}[38;5;8m${_npx}${number} "
	PS1="${prefix}$(get_ps1)"
}
function _ucd_cleanup(){
	rm "/tmp/cd_history_$$" 2>/dev/null
}
PROMPT_COMMAND="_ucd_update_prompt;${PROMPT_COMMAND}"
trap "_ucd_cleanup" EXIT

## ALIASES AND SHORTCUTS
# ALIAS FUNCTIONS
function toilet (){
	command toilet -w "$COLUMNS" -d "$HOME/.config/toilet" -f "miniwi" "$@"
}

NOTES_DIR="$HOME/Documents/Notes"
mkdir -p "$NOTES_DIR"
function note(){
	# ensure notes location exists
	# sanitized
	if [ -z "$1" ]; then
		$EDITOR "$NOTES_DIR/note.md"
		return
	else
		# has .md ending
		[ "$(echo "$1" | grep -o '...$')" == '.md' ] && target="${NOTES_DIR}/$1" || target="${NOTES_DIR}/$1.md"
		$EDITOR "$target"
		return
	fi
}
function notes(){
	$EDITOR "$(ls $NOTES_DIR | fzf --height=10)"
}
function _note_complete(){
	COMPREPLY=()
	local cur="${COMP_WORDS[COMP_CWORD]}"
	local candidates=$(ls "$NOTES_DIR")

	if [[ "$cur" == *[*?[]* ]]; then
		# match against glob
		for file in $candidates; do
			if [[ "$file" == $cur ]]; then
				COMPREPLY+=("$file")
			fi
		done
	else
		# match against prefix (case insensitive)
		while read -r file; do
			local cur_lower=$(echo "$cur" | tr '[:upper:]' '[:lower:]')
			if [[ $(echo "$file" | tr '[:upper:]' '[:lower:]') == "$cur_lower"* ]]; then
				COMPREPLY+=("$file")
			fi
		done <<< "$candidates"
	fi
}
complete -F _note_complete note

# ALIAS ALIAS
alias n=ncmpcpp
alias r="ranger" 
alias l='ls -CF'
alias t="toilet"
alias rangre="ranger" #just because I always mistype
alias rg="rg --color=always"
alias bc="bc -l"
alias mux="tmuxinator"
alias sbash="source ~/.bashrc"
alias gs="git -c color.ui=always status"
alias gss="git -c color.ui=always diff --shortstat"
alias wgs="watch git -c color.ui=always status"
alias la="ls --color=no"
alias ftb="java -jar ~/Downloads/FTB_Launcher.jar";
alias cdqmk="cd ~/qmk_firmware/keyboards/lily58/keymaps/Godje/";
alias cddot="cd $DOTFILES";
alias jellyfin="flatpak run com.github.iwalton3.jellyfin-media-player"
alias yta="yt-dlp --format bestaudio"
alias walpal="wal -i \"$WALLPAPER\""
alias ubuntu_codename="lsb_release -cs 2>/dev/null"
alias pdf="tmuxinator start pdf"
alias bclock="watch -t -n1 -p ""'""toilet -f future \$(date) -w \$COLUMNS | boxit | centerit -q""'"
alias killsteam="ps aux | grep steam | sed 's/\( \)\{1,\}/ /g' | cut -d' ' -f2 | xargs kill"
# usage: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Edit alias
alias ecfg="vim ~/.config/i3/config"
alias ebash="vim ~/.bashrc"
alias evrc="vim ~/.vimrc"
alias vims="vim -S vimsession.vim"
alias vimm="nvim"
which nvim >/dev/null && alias vim="nvim"
alias nvims="nvim -S Session.vim"

# TMUX shortcuts
alias tlist="tmux list-sessions"
alias tattach="tmux attach -t"
alias tnew="tmux new-session -t "'$(basename "$PWD"'" | cut -d' ' -f1)"
function tach(){
	if [[ -z "$1" ]]; then
		echo "usage: tach <session-name>. available sessions:"
		tmux list-sessions
	else
		tmux attach -t "$*"
	fi
}

alias late="ssh -o ForwardAgent=no -o IdentitiesOnly=yes -i ~/.ssh/late_throwaway late.sh"
## END ALIASES ##

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
