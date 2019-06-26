#! /bin/bash -
#
# Package:   VAPALS-ELCAP
# File:      backup-env.sh
# Summary:   Back up a YottaDB/GT.M instance in a VAPALS-ELCAP environment
# Author:    David Wicksell <dlwicksell@fourthwatchsoftware.com>
# Copyright: Copyright © 2019 Fourth Watch Software LC
# License:   See $HOME/run/routines/SAMIUL.m

source $HOME/etc/env.conf
set -e

function usage {
    echo "Info:  Back up a YottaDB instance in a VAPALS-ELCAP environment"
    echo "Usage: $0     # Log to console and $logfile"
    echo "       $0 -q  # Log only to $logfile"
    echo "       $0 -v  # Increase logging verbosity"
    echo "       $0 -h  # Display this help menu"
}

logfile="$HOME/var/log/$(basename $0 .sh).log"
datetime=$(date +%Y%m%d%H%M)
backupdir="$HOME/data/backups/$datetime"

trap "rm -rf $backupdir*; echo -e \"\n[$(date)]: Interrupt $(basename $0) $@\"; exit 127" SIGINT SIGQUIT SIGABRT SIGTERM

while getopts :hqv OPTION
do
    case $OPTION in
        q)  quiet="on"
            ;;
        v)  verbose="-v"
            ;;
        h)  usage
            exit 0
            ;;
        *)  usage
            exit 1
            ;;
    esac
done

[[ ! -d $backupdir ]] && mkdir -p $backupdir/{data/globals,data/journals,run/routines}
[[ $quiet == on ]] && exec &> $logfile || exec &> >(tee $logfile)

echo "[$(date)]: Start $(basename $0) $@"
echo

echo "[$(date)]: Backing up the global directory..."
cp $verbose -p $gtmgbldir $backupdir/data/globals
$gtm_dist/mumps -run GDE << EOF &> $backupdir/data/globals/osehra.gde.out
show -all
quit
EOF
echo

echo "[$(date)]: Backing up the database..."
$gtm_dist/mupip backup -online -newjnlfiles \* $backupdir/data/globals
echo

echo "[$(date)]: Backing up the journals..."
cp $verbose -a $HOME/data/journals $backupdir/data
echo

echo "[$(date)]: Backing up the routines..."
cp $verbose -a $HOME/run/routines $backupdir/run
echo

echo "[$(date)]: Compressing backup..."
tar -C $backupdir $verbose -czf $backupdir.tgz .
echo

echo "[$(date)]: Cleaning up..."
rm $verbose -rf $backupdir
echo

echo "[$(date)]: Finish $(basename $0) $@"

exit 0
