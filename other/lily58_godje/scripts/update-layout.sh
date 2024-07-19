#!/bin/bash

JSON_DEFAULT_LOCATION="$DOTFILES/lily58_godje/*.json"
CONVERTED_C_FILE="$DOTFILES/lily58_godje/misc/keymap_layout.c"
TEMPLATE_HALF_ONE="$DOTFILES/lily58_godje/misc/template1.c"
TEMPLATE_HALF_TWO="$DOTFILES/lily58_godje/misc/template2.c"
FINAL_FILE="$DOTFILES/lily58_godje/keymap.c"

qmk json2c $JSON_DEFAULT_LOCATION -o $CONVERTED_C_FILE

# Removing the import line
tmpfile=$(mktemp);
sed '1d' $CONVERTED_C_FILE > $tmpfile; mv $tmpfile $CONVERTED_C_FILE;

cat $TEMPLATE_HALF_ONE $CONVERTED_C_FILE $TEMPLATE_HALF_TWO > $FINAL_FILE;
