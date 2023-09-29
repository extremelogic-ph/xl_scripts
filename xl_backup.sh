
#!/bin/bash
#      File Name: xl_backup.sh
#        Created: 20150213
#        Purpose: backup a file or folder in a specified backup folder 
#                 and moves it to the back up folder
#  Modifications: 20150213 initial release
#    Main Author: Extreme Logic

# TODO Expand backup folder to have sub folders for year and month 

MAIN_AUTHOR_EMAIL=support@extremelogic.ph

function displayUsage {
  echo ""
  echo "Usage: ${0##*/} [file or folder to backup]"
  echo ""
  echo "Report bugs to: "$MAIN_AUTHOR_EMAIL
  echo ""
}

# check argument count
if [ "$#" = 0 ]; then
  echo ""
  echo "Error. Invalid argument."
  displayUsage
  exit 1
fi

# check inputs
for CURRENT_ITEM in "$@"
do
  if   [ ! -d "${CURRENT_ITEM}" ] && [ ! -f "${CURRENT_ITEM}" ]; then
    echo "Error. ${CURRENT_ITEM} is not a valid file or directory.";
    displayUsage
    exit 1
  fi
done

PATH_FOLDER_BACKUP=backup
FLAG_ARCHIVE=true
PARAM_TARGET=$1
VAR_DATE=`date +%Y%m%d-%H%M%S`
PATH_FOLDER_BACKUP_NEW=$PATH_FOLDER_BACKUP/$VAR_DATE

if [ -d $PATH_FOLDER_BACKUP ]; 
then
  echo ""
  echo "Using folder '"$PATH_FOLDER_BACKUP"' to backup data."
else
  echo ""
  echo "Creating backup folder '"$PATH_FOLDER_BACKUP"'."
  mkdir $PATH_FOLDER_BACKUP
  if [ ! "$?" = 0 ]; then
    echo "Error. Unable to create backup folder. '"$PATH_FOLDER_BACKUP"'."
    exit 1
  fi
fi

if [ -d $PARAM_TARGET ];
then
  mkdir $PATH_FOLDER_BACKUP_NEW
else
  if [ -f $PARAM_TARGET ];
  then
    mkdir $PATH_FOLDER_BACKUP_NEW
  else
    echo "Error. Target $PARAM_TARGET does not exist. Will not proceed."
    exit 1
  fi
fi

if [ -d $PATH_FOLDER_BACKUP_NEW ];
then
  echo "Created folder '$VAR_DATE' under '$PATH_FOLDER_BACKUP'"

  for CURRENT_ITEM in "$@"
  do
    if   [ -d "${CURRENT_ITEM}" ]; then
      echo "Performing backup for directory '$CURRENT_ITEM'";
      cp -r $CURRENT_ITEM $PATH_FOLDER_BACKUP_NEW
    elif [ -f "${CURRENT_ITEM}" ]; then
      echo "Performing backup for file '$CURRENT_ITEM'";
      cp $CURRENT_ITEM $PATH_FOLDER_BACKUP_NEW
    fi
  done

  if [ "$FLAG_ARCHIVE" = "true" ]; then
    cd $PATH_FOLDER_BACKUP
    VAR_ARCHIVE_NAME=${VAR_DATE}.tar.gz
    tar -zcf $VAR_ARCHIVE_NAME $VAR_DATE
    rm -fr $VAR_DATE
    echo "Created archive '$VAR_ARCHIVE_NAME'"
  fi

echo Done backup.
exit 0
