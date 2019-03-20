#! /bin/bash -
#
# Package:   VAPALS-ELCAP
# File:      start-env.sh
# Summary:   Start YottaDB/GT.M services in a VAPALS-ELCAP environment
# Author:    David Wicksell <dlwicksell@fourthwatchsoftware.com>
# Copyright: Copyright © 2019 Fourth Watch Software LC
# License:   See $HOME/run/routines/SAMIUL.m

if [[ -f $HOME/etc/env.conf ]]
then
    source $HOME/etc/env.conf
else
    echo "Missing environment configuration file [$HOME/etc/env.conf]" >&2
    exit 2
fi

function usage {
    echo "Info:  Start YottaDB services in a VAPALS-ELCAP environment"
    echo "Usage: $0     # Log to console and $logfile"
    echo "       $0 -q  # Log only to $logfile"
    echo "       $0 -h  # Display this help menu"
}

script=$(basename $0)
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

echo "[$(date)]: Start $script $@"
echo

echo "[$(date)]: Ensuring journaling is enabled..."
[[ $quiet == on ]] && journal-enable.sh -q || journal-enable.sh
echo

mprocesses=$(lsof -t $HOME/data/globals/*.dat)
if [[ -z $mprocesses ]]
then
    echo "[$(date)]: Ensuring database is in a consistent state..."
    $gtm_dist/mupip journal -recover -backward $HOME/data/journals/osehra.mjl
    $gtm_dist/mupip journal -recover -backward $HOME/data/journals/perf.mjl
    echo

    echo "[$(date)]: Shutting down the database..."
    $gtm_dist/mupip rundown -relinkctl
    $gtm_dist/mupip rundown -region \*
    echo
fi

tmstatus=$($gtm_dist/mumps -run %XCMD 'write $data(^%ZTSCH("RUN"))#2')
echo "[$(date)]: Taskman status = $tmstatus"
if [[ $tmstatus -eq 0 ]]
then
    cd $gtm_log

    echo "[$(date)]: Starting Taskman..."
    $gtm_dist/mumps -run START^ZTMB

    sleep 1

    tmstatus=$($gtm_dist/mumps -run %XCMD 'write $data(^%ZTSCH("RUN"))#2')
    echo "[$(date)]: Taskman status = $tmstatus"

    cd - > /dev/null
fi
echo

mwsstatus=$($gtm_dist/mumps -run %XCMD 'write $get(^VPRHTTP(0,"listener"),"M Web Server not installed")')
echo "[$(date)]: M Web Server status = $mwsstatus"
if [[ $mwsstatus == stopped ]]
then
    cd $gtm_log

    echo "[$(date)]: Starting the M Web Server..."
    $gtm_dist/mumps -run GO^VPRJREQ

    sleep 1

    mwsstatus=$($gtm_dist/mumps -run %XCMD 'write $get(^VPRHTTP(0,"listener"),"M Web Server not installed")')
    echo "[$(date)]: M Web Server status = $mwsstatus"

    cd - > /dev/null
fi
echo

echo "[$(date)]: Finish $script $@"

exit 0
