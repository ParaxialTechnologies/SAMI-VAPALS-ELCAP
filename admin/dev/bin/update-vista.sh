#!/bin/bash

# Update Vista to match the latest backup of Avicenna

# Don't run on Avicenna
if [ ! $Docker_Env ] ; then
    echo "This script is intended for use in a Docker container!"
    exit
fi

echo "Updating Vista"

cd $HOME

$HOME/bin/stop-env.sh

$HOME/bin/journal-disable.sh

$gtm_dist/mupip extract -select=%ZTSCH,%ZTSK tm-$$.zwr
TMEXTRACT=$?

echo "Updating the database"
rm data/globals/*
rm data/journals/*
cd data/backups
aws s3 cp s3://avicenna.fiscientific.com/backup/latest.tgz .

echo "Extracting the database"
tar -xzvf latest.tgz
rm latest.tgz
mv * $HOME/data/globals/

cd -

[[ $TMEXTRACT == 0 ]] && $gtm_dist/mumps -run %XCMD 'kill ^%ZTSCH,^%ZTSK'

$HOME/bin/journal-enable.sh

$gtm_dist/mupip load tm-$$.zwr && rm tm-$$.zwr

echo "Updating the 'run' directory"
cd $HOME/run
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github_fiscientific_vapals_docker
# Reset this repo so we can pull
git reset --hard HEAD
# Delete untracked files so we can pull
untracked_files=$(git ls-files --others --exclude-standard)
if [ ! -z "${untracked_files}" ] ; then
    echo "Deleting untracked files from the 'run' directory"
    for i in ${untracked_files}
    do
        echo "Deleteing ${1}"
        rm ${i}
    done
fi
git pull
ssh-add -d ~/.ssh/github_fiscientific_vapals_docker
cd $HOME

echo "Updating the VA-PALS repo"
cd $HOME/lib/silver/va-pals
git pull
cd $HOME/lib/silver/a-sami-vapals-elcap--vo-osehra-github
git pull

cd $HOME

$HOME/bin/start-env.sh

if [[ $TMEXTRACT != 0 ]]
then
    $gtm_dist/mumps -run %XCMD 'do RESTART^ZTMB' <<< YES
fi

$gtm_dist/mumps -run %XCMD 'do go^%webreq'

echo "Finished updating Vista"
