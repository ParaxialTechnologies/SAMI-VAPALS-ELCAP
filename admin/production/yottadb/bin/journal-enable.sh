#! /bin/bash -
#
# Package:   VAPALS-ELCAP
# File:      journal-enable.sh
# Summary:   Enable YottaDB/GT.M journaling in a VAPALS-ELCAP environment
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
    echo "Info:  Enable YottaDB journaling in a VAPALS-ELCAP environment"
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

echo "[$(date)]: Enabling the journals..."
$gtm_dist/mupip set -journal="enable,on,before,file=$HOME/data/journals/osehra.mjl" -file $HOME/data/globals/osehra.dat
$gtm_dist/mupip set -journal="enable,on,before,file=$HOME/data/journals/perf.mjl" -file $HOME/data/globals/perf.dat
echo

echo "[$(date)]: Finish $script $@"

exit 0
