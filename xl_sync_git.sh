#!/bin/bash
#    File Name: xl_sync_git.sh
#      Created: 20201104
#      Purpose: Try to sync all repo
#  Main Author: Extreme Logic PH

CWD=`pwd`

for d in `find $CWD -name ".git" -type d -maxdepth 2`;
do
    REPO_FOUND=true
    cd $d/..
    PROJECT_DIR=`pwd`
    REMOTE_NAME=`git remote`
    DEFAULT_BRANCH=`git remote show ${REMOTE_NAME} | sed -n '/HEAD branch/s/.*: //p'`
    CURRENT_BRANCH=`git branch --show-current`
    if [ "$DEFAULT_BRANCH" == "$CURRENT_BRANCH" ]; then
      echo "Attempting to sync pull ${PROJECT_DIR}"
      git pull
    else
      if [ -z "$DEFAULT_BRANCH" ]
      then
        echo "Unable to fetch ${PROJECT_DIR}. Cannot determine default branch"
      else
        echo "Attempting to sync fetch ${PROJECT_DIR}"
        git fetch $REMOTE_NAME $DEFAULT_BRANCH:$DEFAULT_BRANCH
      fi
    fi
done

if [ "true" != "$REPO_FOUND" ]; then
  echo "No repo in current directory. Nothing updated"
fi
