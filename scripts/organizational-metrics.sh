# Discover the modules that are shared between multiple programmers
docker run -v $PWD:/data -it code-maat-app -l /data/hib_evo.log -c git -a authors

# Calculate temporal coupling over a day
docker run -v $PWD:/data -it code-maat-app -l /data/hib_evo.log -c git -a coupling --temporal-period 1

# Identify main developers
docker run -v $PWD:/data -it code-maat-app -l /data/hib_evo.log -c git -a main-dev > main_devs.csv

# Identify main developers by removed code
docker run -v $PWD:/data -it code-maat-app -l /data/hib_evo.log -c git -a refactoring-main-dev > refactoring_main_devs.csv

# Calculate individual contributions
docker run -v $PWD:/data -it code-maat-app -l /data/hib_evo.log -c git -a entity-ownership