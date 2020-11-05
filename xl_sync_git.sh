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
    echo "Attempting to sync $i"
    CURRENT_BRANCH=`git branch --show-current`
    if [ "master" == "$CURRENT_BRANCH" ]; then
      git pull
    else
      git fetch origin master:master
    fi
    cd ..
  fi
done

if [ "true" != "$REPO_FOUND" ]; then
  echo "No repo in current directory. Nothing updated"
fi
