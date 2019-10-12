#!/bin/bash


BASE_DIR=$1

if [[ -z $BASE_DIR ]];
then
    echo `date`" - Missing mandatory arguments: path to clone the code-maat repository."
    echo `date`" - Usage: ./create-offender-profile.sh [your-root-folder]"
    exit 1
fi

cd $BASE_DIR

# Clone code-maat repository
git clone git@github.com:adamtornhill/code-maat.git && cd code-maat

# Move to 2013 in the Code Maat repository:
git checkout `git rev-list -n 1 --before="2013-11-01" master`

# Get the detailed log
echo "Get the detailed log..."
git log --numstat

# Generate a more compact version
echo "Generate a more compact version: [commit_hash_id] [author] [date] [commit_message]"
git log --pretty=format:'[%h] %an %ad %s' --date=short --numstat --before=2013-11-01 > maat_evo.log

# Get a first summary analysis
maat -l maat_evo.log -c git -a summary