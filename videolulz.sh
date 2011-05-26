#!/bin/bash

# Configuration 
dir=/var/data/FONReports/sounds/up/videos/ # basedir
list=$dir/list.txt # List of youtube videos
stats=/tmp/stats.txt # Registry of played videos
data=$dir/data/ # Temporal cache
introvideo=$data/intro.flv # An optional intro before playing every video
youtubedl=/home/champi/bin/youtube-dl # Path to youtube-dl

##
# Play a video from youtube using mplayer in fullscreen.
#
# It uses a cache system. If the video was played before
# it won't be downloaded again.
#
# @param string URL of a youtube video to be played.
function playvideo
{
	video=$1
	if [ $(echo $video|grep http -c) -ge 1 ]
	then
		file=$data/$($youtubedl "$video" --get-filename)
		if [ ! -f $file ]
	        then
	                $youtubedl "$video" -c -o $file
	        fi
	else
		file=$data/$video
	fi

	playintro=""
	if [ -f $introvideo ]
	then
		playintro=$introvideo
	fi

	DISPLAY=:0.0 mplayer -fs $playintro $file
	echo $video >> $stats
}

##
# Select a video from the list
#
# First we look for any video marked with a "*".
# If none we get a random one and check the latest 20 played videos
# to avoid repeating
function selectvideo
{
	# First select those marked with an "*"
	video=$(grep -e ^\* $list | sed 's/^*//'|head -1|cut -f1 -d" ")
	if [ "$video" ]
	then
		sed -i 's/^*//' $list
		echo $video
		exit
	fi

	# If none selected, choose a random one
	views=100
	until [ $views -lt 1 ]
	do
		video=$(sort -R $list|grep -v -e '^\B' | head -1|cut -f1 -d" ")
	        views=$(tail -20 $stats 2>/dev/null | grep "$video" -c)
	done
	echo $video
}

video=$(selectvideo)
playvideo $video
