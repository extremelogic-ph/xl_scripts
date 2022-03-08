#!/bin/bash
#    File Name: xl_sync_git.sh
#      Created: 20201104
#      Purpose: Try to sync all repo
#  Main Author: Extreme Logic PH

shopt -s nullglob
array=(*/)
shopt -u nullglob

for i in "${array[@]}"
do
  if [ -d "$i/.git" ]; then
    REPO_FOUND=true
    cd $i
    REMOTE_NAME=`git remote`
    DEFAULT_BRANCH=`git remote show ${REMOTE_NAME} | sed -n '/HEAD branch/s/.*: //p'`
    CURRENT_BRANCH=`git branch --show-current`
    if [ "$DEFAULT_BRANCH" == "$CURRENT_BRANCH" ]; then
      echo "Attempting to sync pull $i"
      git pull
    else
      echo "Attempting to sync fetch $i"
      git fetch $REMOTE_NAME $DEFAULT_BRANCH
    fi
    cd ..
  fi
done

if [ "true" != "$REPO_FOUND" ]; then
  echo "No repo in current directory. Nothing updated"
fi
