#!/bin/bash
set -e

# For getting into the container and taking a look
docker run -v $PWD:/data -it --entrypoint /bin/bash code-maat-app

# List the content of the folder /data inside the container (we should see the same that in the current directory, $PWD)
docker run -v $PWD:/data -it --entrypoint /bin/ls code-maat-app /data

# Run maat with the generated log file existing in the current directory
docker run -v $PWD:/data -it code-maat-app -l /data/maat_evo.log -c git -a summary

# Analyze change frequencies (identify the parts of the code with most developer activity)
docker run -v $PWD:/data -it code-maat-app -l /data/maat_evo.log -c git -a revisions

# Counting lines with cloc
cloc ./ --by-file --csv --quiet

# Merge complexity and effort
docker run -v $PWD:/data -it code-maat-app -l /data/maat_evo.log -c git -a revisions > maat_freqs.csv
cloc ./ --by-file --csv --quiet --report-file=maat_lines.csv
wget https://s3.amazonaws.com/CodeMaatDistro/scripts0.4.zip && unzip scripts0.4.zip && mv 'scripts 4' scripts -f
python scripts/merge_comp_freqs.py maat_freqs.csv maat_lines.csv

# Manually run lein (e.g. from inside the container)
lein run -l /data/maat_evo.log -c git