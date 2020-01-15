#!/bin/sh

# oneliner to get the dirname of where the script is running from
# https://stackoverflow.com/a/246128
# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";

# Script's arguments:
# $0 - the actual file
# $1 - the URL

DIR=$(dirname "$0")
urls=$("$DIR/pytools/bandscrape.py" $1);
ehit=$?

if [ $ehit -ne 0 ]; then
	echo "Error getting the URLs of the albums";
	exit 1;
fi

for url in $urls
do
	album_title=${url##*/}
	echo "";
	echo "==========";
	echo "Downloading $album_title";
	echo "==========";
	mkdir $album_title && \
	cd $album_title && \
	youtube-dl -f bestaudio $url && \
	cd ../;
	echo "==========";
	echo "Downloaded $album_title";
	echo "==========";
	echo "";
done
