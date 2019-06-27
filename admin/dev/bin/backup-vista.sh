#!/bin/bash

# This script backs up a specially configured OSEHRA VistA environment. Future versions will be more generalized and include options.
# 
# Journals are not preserved.

# Don't run in Docker containers
# Credential-based safeguards are also in place
if [ $Docker_Env ] ; then
    echo "This script is intended for use on Avicenna (the real one)!"
    exit 0
fi

username=`whoami`
hostname=`hostname -f`
timestamp=`date +%Y%m%d-%H%M%S`
# prefix="$username@$hostname-$timestamp"
prefix="$timestamp"

cd $HOME
mkdir -p data/backups/$prefix

echo "Backing up the database"
mupip backup -newjnlfiles "*" data/backups/$prefix

echo "Copying the globals directory"
cp data/globals/osehra.gld data/backups/$prefix/

echo "Compressing backup."
cd data/backups/$prefix
tar -czvf $prefix.tgz *
cd $HOME

echo "Copying the database backup to S3"
aws s3 cp data/backups/$prefix/$prefix.tgz s3://avicenna.fiscientific.com/backup/

aws s3 cp s3://avicenna.fiscientific.com/backup/$prefix.tgz s3://avicenna.fiscientific.com/backup/latest.tgz

echo "Cleaning up"
rm -rf data/backups/*

echo "Backing up the 'run' directory"
cd run
# Set up GitHub credentials
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github_fiscientific_vapals_avicenna
# Commit & push
git add -A
git commit -am "Update repo via Vista backup script."
git push
ssh-add -d ~/.ssh/github_fiscientific_vapals_avicenna

cd $HOME

echo "Finished backing up the database"

exit 0
