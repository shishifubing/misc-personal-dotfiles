#!/bin/sh

if [ ! "$1" ]; then
  date=`date +"%Y-%m-%d"`
else
  if [ ! "$2" ]; then
    date=`date +"%Y-%m-"`"$1"
  else
    if [ ! "$3" ]; then
      date=`date +"%Y-"`"$2-$1"
    else
      date="$3-$2-$1"
    fi
  fi
fi

export GIT_AUTHOR_DATE="$date 00:00:00"
export GIT_COMMITTER_DATE="$date 00:00:00"

git add . && git commit -m update && git push origin