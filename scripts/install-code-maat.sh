#!/bin/bash
set -e

BASE_DIR=$1

if [[ -z $BASE_DIR ]];
then
    echo `date`" - Missing mandatory arguments: path to clone the code-maat repository."
    echo `date`" - Usage: ./create-offender-profile.sh [your-root-folder]"
    exit 1
fi

cd $BASE_DIR

git clone git@github.com:adamtornhill/code-maat.git code-maat-now && cd code-maat-now
docker build -t code-maat-app .