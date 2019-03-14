#! /bin/bash -
#
# Package:   VAPALS-ELCAP
# File:      stop-env.sh
# Summary:   Stop YottaDB/GT.M services in a VAPALS-ELCAP environment
# Author:    David Wicksell <dlwicksell@fourthwatchsoftware.com>
# Copyright: Copyright © 2019 Fourth Watch Software LC
# License:   See $HOME/run/routines/SAMIUL.m

source $HOME/etc/env.conf

function usage {
    echo "Info:  Stop YottaDB services in a VAPALS-ELCAP environment"
    echo "Usage: $0     # Log to console and $logfile"
    echo "       $0 -q  # Log only to $logfile"
    echo "       $0 -h  # Display this help menu"
}

logfile="$HOME/var/log/$(basename $0 .sh).log"

while getopts :hq OPTION
do
    case $OPTION in
        q)  quiet="on"
            ;;
        h)  usage
            exit 0
            ;;
        *)  usage
            exit 1
            ;;
    esac
done

[[ $quiet == on ]] && exec &> $logfile || exec &> >(tee $logfile)

echo "[$(date)]: Start $(basename $0) $@"
echo

mwsstatus=$($gtm_dist/mumps -run %XCMD 'write $get(^VPRHTTP(0,"listener"),"M Web Server not installed")')
echo "[$(date)]: M Web Server status = $mwsstatus"
if [[ $mwsstatus == starting || $mwsstatus == running ]]
then
    echo "[$(date)]: Stopping the M Web Server..."
    $gtm_dist/mumps -run STOP^VPRJREQ

    sleep 1

    mwsstatus=$($gtm_dist/mumps -run %XCMD 'write $get(^VPRHTTP(0,"listener"),"M Web Server not installed")')
    echo "[$(date)]: M Web Server status = $mwsstatus"
fi
echo

tmstatus=$($gtm_dist/mumps -run %XCMD 'write $data(^%ZTSCH("RUN"))#2')
echo "[$(date)]: Taskman status = $tmstatus"
if [[ $tmstatus -eq 1 ]]
then
    echo "[$(date)]: Stopping Taskman..."
$gtm_dist/mumps -run %XCMD 'set U="^" do STOP^ZTMKU' << EOF
yes
yes
yes
EOF

    while true
    do
        tmstatus=$($gtm_dist/mumps -run %XCMD 'write $data(^%ZTSCH("RUN"))#2')
        [[ $tmstatus == 0 ]] && echo "[$(date)]: Taskman status = $tmstatus" && break
        sleep 5
    done
fi
echo

mprocesses=$(pgrep -u ${USER:-osehra} mumps)
if [[ -n $mprocesses ]]
then
    echo "[$(date)]: Stopping remaining Mumps processes nicely..."
    for proc in ${mprocesses}
    do
        mupip stop $proc
    done
fi

mprocesses=$(pgrep -u ${USER:-osehra} mumps)
if [[ -n $mprocesses ]]
then
    echo "[$(date)]: Stopping remaining Mumps processes nicely one more time..."
    pkill -u ${USER:-osehra} -SIGTERM mumps
    echo
fi

mprocesses=$(pgrep -u ${USER:-osehra} mumps)
if [[ -n $mprocesses ]]
then
    echo "[$(date)]: Stopping remaining Mumps processes forcefully..."
    pkill -u ${USER:-osehra} -SIGKILL mumps
    echo
fi

mprocesses=$(lsof -t $HOME/data/globals/*.dat)
[[ -z $mprocesses ]] && echo "[$(date)]: Shutting down the database..." && $gtm_dist/mupip rundown -region \* && echo

echo "[$(date)]: Finish $(basename $0) $@"

exit 0
