#! /bin/bash -
#
# Package:   VAPALS-ELCAP
# File:      stop-env.sh
# Summary:   Stop YottaDB/GT.M services in a VAPALS-ELCAP environment
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
    echo "Info:  Stop YottaDB services in a VAPALS-ELCAP environment"
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

tmstatus=$($gtm_dist/mumps -run %XCMD 'write $get(^%ZTSCH("RUN"))')
if [[ $tmstatus =~ [0-9,] ]]
then
    echo "[$(date)]: Taskman status = running ($tmstatus)"
    echo "[$(date)]: Stopping Taskman..."
$gtm_dist/mumps -run %XCMD 'set U="^" do STOP^ZTMKU' << EOF
yes
yes
yes
EOF

    count=0
    while true
    do
        tmstatus=$($gtm_dist/mumps -run %XCMD 'write $get(^%ZTSCH("RUN"))')
        [[ $tmstatus == "" ]] && echo "[$(date)]: Taskman status = ${tmstatus:-stopped}" && break

        sleep 5
        count=$((count + 5))

        if [[ $count -ge 30 ]]
        then
            tmstatus=$($gtm_dist/mumps -run %XCMD 'write $get(^%ZTSCH("RUN"))')
            if [[ $tmstatus == "" ]]
            then
                echo "[$(date)]: Taskman status = ${tmstatus:-stopped}"
            else
                echo "[$(date)]: Taskman status = running ($tmstatus)"
                echo "[$(date)]: Taskman will be shutdown with the rest of the Mumps processes"
            fi

            break
        fi
    done
elif [[ $tmstatus == "" ]]
then
    echo "[$(date)]: Taskman status = ${tmstatus:-stopped}"
else
    echo "[$(date)]: Taskman status = $tmstatus"
    echo "[$(date)]: Taskman needs to be reconfigured"
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
if [[ -z $mprocesses ]]
then
    echo "[$(date)]: Shutting down the database..."
    $gtm_dist/mupip rundown -relinkctl
    $gtm_dist/mupip rundown -region \*
    echo
fi

mstatus=$(ps -u $USER -o pid,cmd | grep mumps | grep -v grep)
echo -e "[$(date)]: Running Mumps processes:\n$mstatus\n"

echo "[$(date)]: Finish $script $@"

exit 0
