#!/bin/bash

# Configuration 
dir=/var/data/FONReports/sounds/up/videos/ # basedir
list=$dir/list.txt # List of youtube videos
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
	file=$data/$($youtubedl "$video" --get-filename)
	
	if [ ! -f $file ]
	then
	        $youtubedl "$video" -c -o $file
	fi

	playintro=""
	if [ -f $introvideo ]
	then
		playintro=$introvideo
	fi

	DISPLAY=:0.0 mplayer -fs $playintro $file
}

# Select the video in the list.
# First select those marked with an "*"
video=$(grep -e ^\* $list | sed 's/^*//')
if [ -z "$video" ]
then
	# If none selected, choose a random one
	video=$(sort -R $list|grep -v -e '^\B' | head -1)
else
	# Removed marked videos
	sed -i 's/^*//' $list
fi

video=$(echo "$video" | cut -f1 -d" ")
playvideo $video
