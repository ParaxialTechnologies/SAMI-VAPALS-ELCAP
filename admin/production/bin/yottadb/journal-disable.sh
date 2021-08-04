#! /bin/bash -
#
# Package:   VAPALS-ELCAP
# File:      journal-disable.sh
# Summary:   Disable YottaDB/GT.M journaling in a VAPALS-ELCAP environment
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
    echo "Info:  Disable YottaDB journaling in a VAPALS-ELCAP environment"
    echo "Usage: $0     # Log to console and $logfile"
    echo "       $0 -q  # Log only to $logfile"
    echo "       $0 -f  # Force the YottaDB database offline (stop all attached processes)"
    echo "       $0 -h  # Display this help menu"
}

script=$(basename $0)
logfile="$HOME/var/log/$(basename $0 .sh).log"

while getopts :hqf OPTION
do
    case $OPTION in
        q)  quiet="on"
            ;;
        f)  force="on"
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

mprocesses=$(pgrep -u ${USER:-osehra} mumps)
if [[ -n $mprocesses && ${force:-off} == off ]]
then
    echo -e "Mumps processes are still running, re-run script with -f to force stop\n"
    usage
    exit 2
fi

echo "[$(date)]: Start $script $@"
echo

if [[ -n $mprocesses && $force == on ]]
then
    echo "[$(date)]: Ensuring environment is stopped..."
    stop-env.sh
    echo
fi

echo "[$(date)]: Disabling the journals..."
$gtm_dist/mupip set -journal="disable" -file $HOME/data/globals/osehra.dat
$gtm_dist/mupip set -journal="disable" -file $HOME/data/globals/perf.dat
echo

echo "[$(date)]: Finish $script $@"

exit 0
