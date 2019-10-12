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

git clone https://github.com/hibernate/hibernate-orm.git && cd hibernate-orm
git checkout `git rev-list -n 1 --before="2013-19-05" master`
git log --pretty=format:'[%h] %an %ad %s' --date=short --numstat --before=2013-09-05 --after=2012-01-01 > hib_evo.log

docker run -v $PWD:/data -it code-maat-app -l /data/hib_evo.log -c git -a summary

# Merge complexity and effort
cloc ./ --by-file --csv --quiet --report-file=hib_lines.csv
docker run -v $PWD:/data -it code-maat-app -l /data/hib_evo.log -c git -a revisions > hib_freqs.csv
python scripts/merge_comp_freqs.py hib_freqs.csv hib_lines.csv

# Visualize the hotspots
wget https://s3.amazonaws.com/CodeMaatDistro/sample0.2.zip && unzip scripts0.2.zip
cd sample/hibernate && python -m SimpleHTTPServer 8888
http://localhost:8888/hibzoomable.html

# Convert from CSV to JSON (D3)
python csv_as_enclosure_json.py -h
python csv_as_enclosure_json.py --structure xxx_lines.csv --weights xxx_freqs.csv