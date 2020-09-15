#!/bin/bash
LOCKFILE=/tmp/zoomlock.lock
if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}` 2> /dev/null; then
    echo "Killing already running zoom"
    pkill -15 -g `cat ${LOCKFILE}`
    # pkill -15 -x zoom
    # wait `cat ${LOCKFILE}`
    sleep 5
    echo "Killed running zoom"
fi
# echo $$ > ${LOCKFILE}

export DISPLAY=:1
cd /home/apps
# printenv
# make sure the lockfile is removed when we exit and then claim it
# trap "pkill -15 -x zoom; exit" INT TERM EXIT
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

# do stuff
timeout -k 20 ${LTIME:-40} nohup zoom "zoommtg://zoom.us/join?action=join&confno=$1" >/dev/null 2>&1 & # detached from terminal
zoompid=$!
echo $zoompid > ${LOCKFILE}

while kill -0 $zoompid 2> /dev/null; do
    # Do stuff
    sleep 10m
    curl ${PUBLIC_URL:-'http://localhost:8080/test'}
done

# rm -f ${LOCKFILE}
# touch /tmp/"$(date +'%d%m%y-%H%M-%S').$1"