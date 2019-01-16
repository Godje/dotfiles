#!/bin/bash


# -- Variables

action=$1
motd="\
usage:\tididit <list|init|add> \n
\tPress Enter and follow the dialogue\n\n\
ididit - Log your daily accomplishments\n\n\
 init\t\tinitiate a program. If not initiated, didits won't be saved\n\
 add\t\tadd a new entry to your didit log\n\
 list\t\tlist the entries for today|week|month|all\
"

# -- Functions

# output that is designed to be outputted. 
function logmsg(){
	echo -e "=" "$1"
}

# creation of the log file and other initiation stuff
function init(){
	logmsg "Initiating the program."
	if [[ $IDIDIT_FILE == "" ]]; then
		IDIDIT_FILE="~/.ididit_log"
		echo "export IDIDIT_FILE=$IDIDIT_FILE" >> ~/.bashrc
	fi

	logmsg "Checking if file already exists..."
	if [[ -f $IDIDIT_FILE ]]; then
		logmsg "File already exists"
	else
		logmsg "Creating the ididit file"
		touch $IDIDIT_FILE
	fi
	logmsg "If you want to change the location of the log file, please edit the IDIDIT_FILE variable in your ~/.bashrc"
}

# creating a didit and putting it into the file
function add(){
	logmsg "Type what you did:"
	echo $*
	read didit
	didtime=$( date +"%D %T" )
	echo $didit $didtime
}

# deleting an entry
function delete(){
	logmsg "Bruh"
}

# listing entries
function list(){
	echo "listing"
}
function clearFile(){
	logmsg "Clearing the ididit file"
	echo "" > $IDIDIT_FILE
	logmsg "File cleared"
}

# -- First argument processing

case "$1" in
	"init")
		init ;;
	"add")
		add $*;;
	"list")
		list $2;;
	"delete")
		delete $2;;
	"clear")
		clearFile ;;
	*)
		echo -e $motd
		;;
esac






# DEVELOPMENT CORNER
#
# Where I stopped:
# You stopped on making the ADD function.
# The date has been figured out. Try add ID and then finding the last id in the text file..
