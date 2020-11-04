#!/bin/bash
#    File Name: xl_sync_git.sh
#      Created: 20201104
#      Purpose: Try to sync all repo
#  Main Author: Extreme Logic PH

shopt -s nullglob
array=(*/)
shopt -u nullglob # Turn off nullglob to make sure it doesn't interfere with anything later
for i in "${array[@]}"
do
  if [ -d "$i/.git" ]; then
    cd $i
    echo "Attempting to sync $i"
    git pull
    cd ..
  fi
done
