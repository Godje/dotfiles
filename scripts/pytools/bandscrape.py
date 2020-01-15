#!/usr/bin/python

# Author - Daniel Mayovskiy (Godje) <comepot.4anell@gmail.com>
# Description - Delivers URLs of all albums on a bandcamp account using the
# URL of the bandcamp account of an artist.

# required - BeautifulSoup4
# installation - pip3 install BeautifulSoup4

import urllib;
import sys;
from bs4 import BeautifulSoup;

def errorExit():
	sys.exit(1);

def exit():
	sys.exit();

def printHelp():
	print "Usage:\n\tbandscrape <artist's url>\n\nDon't forget the protocol (http, https)";
	errorExit();

if( len( sys.argv ) == 1):
	printHelp();
	exit();

url = sys.argv[1];
page = urllib.urlopen(url).read();

soup = BeautifulSoup(page, 'html.parser');

try:
	group = soup.find('div', attrs={"class":"leftMiddleColumns"})
	albumElements = group.find_all('li');
	albumUrls = [];
	for album in albumElements:
		albumUrls.append( url + album.a["href"] );
	for url in albumUrls:
		print url;
except:
	errorExit();
