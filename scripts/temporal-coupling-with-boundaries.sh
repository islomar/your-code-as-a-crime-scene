#!/bin/bash

docker run -v $PWD:/data -it code-maat-app -l /data/maat_evo.log -c git -a coupling -g /data/maat_src_test_boundaries.txt