#! /bin/bash -
#
# Package:   VAPALS-ELCAP
# File:      journal-purge.sh
# Summary:   Purge old YottaDB/GT.M journals in a VAPALS-ELCAP environment
# Author:    David Wicksell <dlwicksell@fourthwatchsoftware.com>
# Copyright: Copyright © 2019 Fourth Watch Software LC
# License:   See $HOME/run/routines/SAMIUL.m

source $HOME/etc/env.conf

function usage {
    echo "Info:  Purge old YottaDB journals in a VAPALS-ELCAP environment"
    echo "Usage: $0            # Log to console and $logfile"
    echo "       $0 -q         # Log only to $logfile"
    echo "       $0 -t         # Perform a trial run"
    echo "       $0 -d <days>  # Days of journals to retain (defaults to 7)"
    echo "       $0 -h         # Display this help menu"
}

logfile="$HOME/var/log/$(basename $0 .sh).log"

while getopts :hqtd: OPTION
do
    case $OPTION in
        q)  quiet="on"
            ;;
        t)  trial="on"
            ;;
        d)  days=$(($OPTARG + 0))

            if [[ $days -lt 1 ]]
            then
                echo -e "-d option must be greater than 0 days\n"
                usage
                exit 2
            fi

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

echo -n "[$(date)]: Purging journals older than ${days:-7} day(s)"
total=$(ls $HOME/data/journals/*.mjl* | wc -l)
if [[ $trial == on ]]
then
    echo " (trial run)..."
    find $HOME/data/journals -name '*.mjl_*' -type f -ctime +$((${days:-7} - 1)) -exec ls -l {} \; | tee $gtm_tmp/junk.$$

    msg="would be"
else
    echo "..."
    find $HOME/data/journals -name '*.mjl_*' -type f -ctime +$((${days:-7} - 1)) -print > $gtm_tmp/junk.$$
    find $HOME/data/journals -name '*.mjl_*' -type f -ctime +$((${days:-7} - 1)) -exec rm -v {} \;

    msg="were"
fi
count=$(cat $gtm_tmp/junk.$$ | wc -l) && rm $gtm_tmp/junk.$$
echo "[$(date)]: A total of $count journal(s) out of $total total journal(s) $msg removed"
echo

echo "[$(date)]: Finish $(basename $0) $@"

exit 0
