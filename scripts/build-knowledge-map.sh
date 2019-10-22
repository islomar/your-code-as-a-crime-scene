# Show the number of commits for each developer and the total number of revisions for that file
docker run -v $PWD:/data -it code-maat-app -l /data/hib_evo.log -a entity-effort

git clone https://github.com/scala/scala.git
git checkout `git rev-list -n 1 --before="2013-12-31" origin/2.11.x`
git log --pretty=format:'[%h] %an %ad %s' --date=short --numstat --before=2013-12-31 --after=2011-12-31  > scala_evo.log
docker run -v $PWD:/data -it code-maat-app -l /data/scala_evo.log -a main-dev > scala_main_dev.csv
cloc ./ --by-file --csv --quiet --report-file=scala_lines.csv
python tools/scripts/csv_main_dev_as_knowledge_json.py --structure scala_lines.csv --owners scala_main_dev.csv --authors scala_author_colors.csv > scala_knowledge_131231.json