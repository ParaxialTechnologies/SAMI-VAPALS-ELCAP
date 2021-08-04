#! /bin/bash -
#
# Package:   VAPALS-ELCAP
# File:      backup-env.sh
# Summary:   Back up a Caché instance in a VAPALS-ELCAP environment
# Author:    David Wicksell <dlwicksell@fourthwatchsoftware.com>
# Copyright: Copyright © 2021 Fourth Watch Software LC
# License:   See $HOME/run/routines/SAMIUL.m in the repo

set -e

function usage {
    echo "Info:  Back up a Caché instance in a VAPALS-ELCAP environment"
    echo
    echo "Usage: $0     # Log to console and $logfile"
    echo "       $0 -q  # Log only to $logfile"
    echo "       $0 -v  # Increase logging verbosity"
    echo "       $0 -t  # Perform a trial run"
    echo "       $0 -h  # Display this help menu"
}

script=$(basename $0)
logdir="${VAPALSDIR:-/ldisk2}/data/log"
logfile="$logdir/$(basename $0 .sh).log"
backupdir="${VAPALSDIR:-/ldisk2}/data/backups/$(date +%Y%m%d%H%M)"
cachedist="/usr/local/lib/cache/2018.1.2.309.5"
quiet="off" verbose="" echo=""

trap "rm -rf $backupdir; echo -e \"\n[$(date)]: Interrupt $script $@\"; exit 127" SIGINT SIGQUIT SIGABRT SIGTERM

while getopts :hqtv OPTION
do
    case $OPTION in
        q)  quiet="on"
            ;;
        v)  verbose="-v"
            ;;
        h)  usage
            exit 0
            ;;
        t)  echo="echo"
            ;;
        *)  usage
            exit 1
            ;;
    esac
done

[[ ! -d $logdir ]] && $echo mkdir -p $logdir
[[ ! -d $backupdir ]] && $echo mkdir -p $backupdir/{global,journal}

if [[ $echo == "" ]]
then
    [[ $quiet == on ]] && exec &>> $logfile || exec &> >(tee -a $logfile)
fi

echo "[$(date)]: Start $script $@"
echo

[[ $echo == echo ]] && echo -e "[$(date)]: Performing a trial run...\n"

echo "[$(date)]: Backing up the database..."

if [[ $echo == echo ]]
then
    cat << EOL
csession vapals -U %SYS ^BACKUP << EOF
1
1
$backupdir/global/CACHE.DAT
Full backup - $(date "+%Y-%m-%d %H:%M:%S")
y
halt
EOF
EOL
elif [[ $verbose == -v ]]
then
    csession vapals -U %SYS ^BACKUP << EOF
1
1
$backupdir/global/CACHE.DAT
Full backup - $(date "+%Y-%m-%d %H:%M:%S")
y
halt
EOF

else
    csession vapals -U %SYS ^BACKUP > /dev/null << EOF
1
1
$backupdir/global/CACHE.DAT
Full backup - $(date "+%Y-%m-%d %H:%M:%S")
y
halt
EOF

fi

echo

echo "[$(date)]: Backing up the journals..."
$echo cp $verbose -a $cachedist/mgr/journal $backupdir
$echo rm $verbose -f $backupdir/journal/cache.lck
echo

echo "[$(date)]: Compressing backup..."
$echo tar -C $(dirname $backupdir) $verbose -czf $backupdir.tgz $(basename $backupdir)
echo

echo "[$(date)]: Cleaning up..."
$echo rm $verbose -rf $backupdir
echo

echo "[$(date)]: Finish $script $@"
echo
echo "================================================================================"
echo

exit 0
