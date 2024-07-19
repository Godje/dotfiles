#!/bin/bash

current_folder=$(pwd)
cd $DOTFILES/lily58_godje/scripts

./update-layout.sh
./compile.sh

qmk flash -km Godje -kb lily58

cd $current_folder
