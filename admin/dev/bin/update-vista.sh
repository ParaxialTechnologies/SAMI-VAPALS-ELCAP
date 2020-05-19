#!/bin/bash

# Update Vista to match the latest backup of VAPALS YottaDB
#
# Don't run on Avicenna

set -e

if [ ! $Docker_Env ] ; then
    echo "This script is intended for use in a Docker container!"
    exit 0
fi

logfile="$HOME/var/log/$(basename $0 .sh).log"

trap "rm -rf $HOME/tmp/latest*; echo -e \"\n[$(date)]: Interrupt $(basename $0) $@\"; exit 127" SIGINT SIGQUIT SIGABRT SIGTERM

exec &> >(tee $logfile)

[[ -d $HOME/tmp/latest ]] && rm -rf $HOME/tmp/latest
mkdir -p $HOME/tmp/latest

echo "[$(date)]: Start $(basename $0) $@"
echo

echo "[$(date)]: Stopping Vista..."
$HOME/bin/stop-env.sh
echo

echo "[$(date)]: Disabling journals..."
$HOME/bin/journal-disable.sh
echo

echo "[$(date)]: Saving Taskman globals..."
$gtm_dist/mupip extract -select=%ZTSCH,%ZTSK tm-$$.zwr
TMEXTRACT=$?
echo

echo "[$(date)]: Removing current database..."
rm -v data/globals/*
rm -v data/journals/*
echo

echo "[$(date)]: Downloading latest backup from S3..."
aws s3 cp s3://backup.fiscientific.org/vapalsyotta/backup/latest.tgz $HOME/tmp/
echo

echo "[$(date)]: Extracting latest backup..."
cd $HOME/tmp
tar -xzf latest.tgz
cd -
echo

echo "[$(date)]: Updating environment config & scripts..."
cp -v $HOME/tmp/latest/run/unix/bin/* $HOME/bin/
cp -rv $HOME/tmp/latest/run/unix/etc/* $HOME/etc/
echo

echo "[$(date)]: Updating routines..."
cp $HOME/tmp/latest/run/routines/* $HOME/run/routines/
echo

echo "[$(date)]: Updating web directory..."
cp -rv $HOME/tmp/latest/www/* $HOME/www/
echo

echo "[$(date)]: Updating database..."
cp -v $HOME/tmp/latest/data/globals/* $HOME/data/globals/
cp -v $HOME/tmp/latest/data/journals/* $HOME/data/journals/
echo

echo "[$(date)]: Loading Taskman globals..."
[[ $TMEXTRACT == 0 ]] && $gtm_dist/mumps -run %XCMD 'kill ^%ZTSCH,^%ZTSK'
$HOME/bin/journal-enable.sh
$gtm_dist/mupip load tm-$$.zwr && rm tm-$$.zwr
echo

echo "[$(date)]: Updating VA-PALS repo..."
cd $HOME/lib/silver/vapals
git pull
cd -
echo

echo "[$(date)]: Starting Vista..."
$HOME/bin/start-env.sh
if [[ $TMEXTRACT != 0 ]]
then
    $gtm_dist/mumps -run %XCMD 'do RESTART^ZTMB' <<< YES
    $gtm_dist/mumps -run %XCMD 'do go^%webreq'
fi
echo

echo "[$(date)]: Cleaning up..."
rm -rf $HOME/tmp/latest
rm -v $HOME/tmp/latest.tgz
echo

echo "[$(date)]: Finish $(basename $0) $@"

exit 0