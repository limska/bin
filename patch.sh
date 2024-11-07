#!/bin/bash

REL=$1
JIRA=$2
SHA1=$3
#MSG=$4
# echo "MSG=$MSG"
# echo "Num arg: $#" 

if [ $# -lt 2 ] ; then
  echo "Usage: $0 <Release> <JIRA> [<sha1>]" 	 
  exit 1 
fi


# MAKE SURE YOU ARE IN A CLONE OF THE DEVELOPMENT FORK (NOT UPSTREAM)
# git remote -v will indicate the clone's origin
echo git checkout release/$REL
echo git pull
# "patch/" in branch naming is important
echo git checkout -b patch/$REL/$JIRA
  
if [ -n "$SHA1" ] ; then 
  echo git cherry-pick $SHA1
fi

#echo git commit -m \"$JIRA - $MSG\"
# Create branch on remote and set your local up to track it
echo git push -u origin patch/$REL/$JIRA
