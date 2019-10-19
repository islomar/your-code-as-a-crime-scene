#!/bin/bash

# Sum of Coupling: how many times a file has been coupled to another one in a commit
docker run -v $PWD:/data -it code-maat-app -l /data/maat_evo.log -c git -a soc

# After identifying a file to focus on (one with lots of SOC) , search with which modules it's coupled to
# entity, coupled,degree,average-revs
# degree: percent of shared commits
docker run -v $PWD:/data -it code-maat-app -l /data/maat_evo.log -c git -a coupling

# Analyze another source code
git clone https://github.com/SirCmpwn/Craft.Net.git
git log --pretty=format:'[%h] %an %ad %s' --date=short --numstat --before=2014-08-08 > craft_evo_complete.log
docker run -v $PWD:/data -it code-maat-app -l /data/craft_evo_complete.log -c git -a soc

# Perform trend analyses of temporal coupling
git log --pretty=format:'[%h] %an %ad %s' --date=short --numstat --before=2013-01-01 > craft_evo_130101.log
docker run -v $PWD:/data -it code-maat-app -l /data/craft_evo_130101.log -c git -a coupling > craft_coupling_130101.csv
git log --pretty=format:'[%h] %an %ad %s' --date=short --numstat --after=2013-01-01 --before=2014-08-08 > craft_evo_140808.log
docker run -v $PWD:/data -it code-maat-app -l /data/craft_evo_140808.log -c git -a coupling > craft_coupling_140808.csv
