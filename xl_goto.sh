#      File Name: xl_goto.sh
#        Created: 20150610
#        Purpose: Quick change directory script
#    Main Author: Extreme Logic PH

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_NAME=xl_goto
FILE_INPUT=$SCRIPT_DIR/${SCRIPT_NAME}.cfg

if [ ! "$#" = 1 ]; then
  echo 
  echo "Usage: . ${SCRIPT_NAME}.sh <choose a number>"
  while read line
  do
    IFS=',' read -r -a array <<< "$line"
    printf '  %s) %s\n' ${array[0]} ${array[1]}
  done < $FILE_INPUT
  echo 
fi

choice=$1

while read line
do
  IFS=',' read -r -a array <<< "$line"
  if [[ $choice = ${array[0]} ]]; then
    cd "${array[2]}"
    break
  fi
done < "$FILE_INPUT"
