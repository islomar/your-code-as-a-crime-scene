git clone git@github.com:nopSolutions/nopCommerce.git

git config diff.renameLimit 2000
git log --pretty=format:'[%h] %an %ad %s' --date=short --numstat --after=2014-01-01 --before=2014-09-25 > nop_evo_2014.log

# Identify expensive change patterns
docker run -v $PWD:/data -it code-maat-app -l /data/nop_evo_2014.log -c git -a coupling -g /data/arch_boundaries.txt

# Use hotspots to assess the severity
docker run -v $PWD:/data -it code-maat-app -l /data/nop_evo_2014.log -c git -a revisions -g /data/arch_boundaries.txt