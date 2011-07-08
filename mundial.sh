#!/bin/bash
dl=
videos="ocBXPLD6nSs Tnt7C2L6d3M XIE_RQHDwlg bVN5zo4KHR4 5HbYjF0ad-E hemjxNYTKco CSkNVlQ6kWw ONUwNddTzLE 1mOwrQc1xMw 5EoZGZ7dNSg v0visb3fDuA gzkT_RtZ_IA cre4ahQANkk VSv1LTaln3k"
files=""

for v in $videos
do
  file=$(youtube-dl --get-filename http://www.youtube.com/watch?v=$v)
  files="$files $file"
  youtube-dl -c -o /tmp/$file http://www.youtube.com/watch?v=$v
done

allfiles=$files
while [ 1 ]
do
  files=$allfiles
  for f in $files
  do
    DISPLAY=:0.0 mplayer -fs /tmp/$f
    if [ $(date +%H) = '19' ]
    then
      # Stop at 19:00
      break
    fi
  done

  if [ $(date +%H) = '19' ]
  then
    # Stop at 19:00
    break
  fi
  sleep 1h
done
  
