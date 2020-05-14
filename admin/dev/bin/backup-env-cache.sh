#! /bin/bash -
#
# Package:   VAPALS-ELCAP
# File:      backup-env-yotta.sh
# Summary:   Back up a Caché instance in a VAPALS-ELCAP environment
# Author:    David Wicksell <dlwicksell@fourthwatchsoftware.com>
# Copyright: Copyright © 2019 Fourth Watch Software LC
# License:   See $HOME/run/routines/SAMIUL.m
#
# Modified:  Alexis Carlson (VEN/ARC ~ KBBW) alexis@fiscientific.com

set -e

#source $HOME/etc/env.conf
logfile="$HOME/var/log/$(basename $0 .sh).log"
timestamp=$(date +%Y%m%d-%H%M%S)
backupdir="$HOME/data/backups/$timestamp"
hostname=$(hostname)

function usage {
    echo "Usage: $(basename $0) [OPTION]"
    echo "Back up a VEN Caché instance."
    echo
    echo "      log to console and $logfile"
    echo "  -q  log only to $logfile"
    echo "  -v  increase logging verbosity"
    echo "  -h  display this help menu"
    echo
}

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

[[ -d $backupdir ]] || mkdir -p $backupdir/{data/databases,data/journals,run}

[[ $quiet == on ]] && exec &> $logfile || exec &> >(tee $logfile)

echo "[$(date)]: Start $(basename $0) $@"
echo

echo "[$(date)]: Backing up user config files..."
cp -p $verbose $HOME/.bash_profile $backupdir/
cp -p $verbose $HOME/.bashrc $backupdir/
echo

echo "[$(date)]: Backing up repos..."
cp -pr $HOME/lib $backupdir/
echo

echo "[$(date)]: Backing up environment config & scripts..."
cp -pr $verbose $HOME/run/unix $backupdir/run/
echo

echo "[$(date)]: Backing up database & routines..."
csession vapals -U %SYS << EOF
DO ^BACKUP
1
1
${backupdir}/data/databases/cache.cbk
Daily backup
y

HALT
EOF
echo

echo "[$(date)]: Backing up journals..."
cp -p $verbose /usr/local/lib/cache/mgr/journal/* $backupdir/data/journals/
echo

echo "[$(date)]: Backing up web directory..."
cp -pr $verbose $HOME/www $backupdir/
echo

echo "[$(date)]: Compressing backup..."
echo $timestamp
tar -czf $HOME/data/backups/$timestamp.tgz $backupdir
echo

echo "[$(date)]: Copying backup to S3..."
aws s3 cp $backupdir.tgz s3://backup.fiscientific.org/$hostname/backup/
echo

echo "[$(date)]: Cleaning up..."
rm -rf $backupdir
rm $verbose $backupdir.tgz
echo

echo "[$(date)]: Finish $(basename $0) $@"

exit 0