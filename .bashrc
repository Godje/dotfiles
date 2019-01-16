# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
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

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

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
		sudo systemctl suspend
	fi
	if [[ "$1" == "lifent" ]]; then
		sudo shutdown -P now
	fi
	if [[ "$1" == "tensei" ]]; then
		sudo shutdown -r now
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
	markdown-pdf -s ~/Documents/scripts/github.css $1
}

export TERM=rxvt-unicode-256color
export EDITOR="vim"
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:~/Documents/scripts/

alias nf="neofetch --w3m --source wallpaper --size 300"
alias memPID="ps aux | awk '{print $2, $4, $11}' | sort -k2rn | head -n 20"
alias ecfg="vim ~/.config/i3/config"
alias ebash="vim ~/.bashrc"
alias evrc="vim ~/.vimrc"
alias exres="vim ~/.Xresources"
alias vims="vim -S vimsession.vim"
alias ls="ls --color=never"
alias r="ranger" 
alias vi="vim"
alias rangre="ranger" #just because I always make mistakes
alias minecraft="java -jar ~/Downloads/Minecraft.jar"

alias screenkey="/media/daniel/therest/linux/builds/screenkey/screenkey"
alias telegram="/media/daniel/therest/linux/installed_software/Telegram &"

export NVM_DIR="/home/daniel/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH-}:/usr/lib32:/usr/lib32/fglrx"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export IDIDIT_FILE=~/.ididit_log
