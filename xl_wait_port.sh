#!/bin/bash
#      File Name: xl_wait_port.sh
#        Created: 20150801
#        Purpose: Wait for a particular port to go up or down
#    Main Author: Extreme Logic Ph

# TODO detect lsof prerequisite 

MAIN_AUTHOR_EMAIL=support@extremelogic.ph

trap trap_ctrl_c INT

function trap_ctrl_c() {
  echo ""
  echo "Warning. ${0##*/} has been interupted."
  echo ""
  exit 1
}

function displayUsage {
  echo ""
  echo "Usage: ${0##*/} [port] [ up | down ]"
  echo "  e.g. ${0##*/} 12004 up"
  echo ""
  echo "Report bugs to: "$MAIN_AUTHOR_EMAIL
  echo ""
}

if [ "$#" -ne 2 ]; then
  displayUsage $0
  exit 1
fi

MODE=$2
PORT_NO=$1

if [[ "up" == $MODE || "down" == $MODE ]]; then
  echo Initiating wait.
else
  displayUsage $0
  exit 1
fi

echo Waiting for port $PORT_NO to go $MODE.
LOOP_FLAG=1
WARN_FLAG=1
while [ "$LOOP_FLAG" -gt 0 ]; do
  LOOP_FLAG=1
  STATUS=`lsof -i :$PORT_NO`
#	check_port.sh $PORT_NO
#	STATUS=$?
  if [ "up" == $MODE ]; then
    if [ "1" -eq "$STATUS" ]; then
      LOOP_FLAG=0
    fi
  else
    if [ "0" = "$STATUS" ]; then
      LOOP_FLAG=0
    fi
  fi
  RESULT=$((WARN_FLAG % 35))
  if [ "$RESULT" -eq "0" ]; then
    echo "Process is taking some time. Please check or wait."
  fi
  sleep 1
  ((WARN_FLAG++))
done
echo Port $PORT_NO is now $MODE.
exit 0
