#! /bin/bash -
#
# Package:   VAPALS-ELCAP
# File:      journal-enable.sh
# Summary:   Enable YottaDB/GT.M journaling in a VAPALS-ELCAP environment
# Author:    David Wicksell <dlwicksell@fourthwatchsoftware.com>
# Copyright: Copyright © 2019 Fourth Watch Software LC
# License:   See /home/osehra/run/routines/SAMIUL.m

source /home/osehra/etc/env.conf

function usage {
    echo "Info:  Enable YottaDB journaling in a VAPALS-ELCAP environment"
    echo "Usage: $0     # Log to console and $logfile"
    echo "       $0 -q  # Log only to $logfile"
    echo "       $0 -h  # Display this help menu"
}

logfile="/home/osehra/var/log/$(basename $0 .sh).log"

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

echo "[$(date)]: Enabling the journals..."
$gtm_dist/mupip set -journal="enable,on,before,file=/home/osehra/data/journals/osehra.mjl" -file /home/osehra/data/globals/osehra.dat
$gtm_dist/mupip set -journal="enable,on,before,file=/home/osehra/data/journals/perf.mjl" -file /home/osehra/data/globals/perf.dat
echo

echo "[$(date)]: Finish $(basename $0) $@"

exit 0
