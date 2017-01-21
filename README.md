# Your code as a crime scene
Practice stuff from the book "Your code as a crime scene"

Author: Adam Tornhill
https://pragprog.com/book/atcrime/code-as-acrime-scene


##Interesting links
[Book forum](https://forums.pragprog.com/forums/367)
[GOTO 2015: Talk from Adam Tornhill](https://www.youtube.com/watch?v=TfZmuS01CN)
[BilboStack 2016: Talk from Vicenç García-Altés](https://vimeo.com/154470784)
https://www.infoq.com/news/2015/03/code-as-a-crime-scene

##Tools
* http://www.adamtornhill.com/code/crimescenetools.htm
  * Executable Code Maat
  * Python scripts
* https://github.com/adamtornhill/code-maat
* Evolution of Code Maat: https://codescene.io/projects


##Steps
1. Move to 2013 in the Code Maat repository:
```
git checkout `git rev-list -n 1 --before="2013-11-01" master`
```

2. Get the detailed log:
`git log --numstat`

3. Generate a more compact version
```
git log --pretty=format:'[%h] %an %ad %s' --date=short --numstat --before=2013-11-01 > maat_evo.log
```

4. Get a first summary analysis
`maat -l maat_evo.log -c git -a summary`
* The option -a is the analysis we want
* With -c, we specify the VCS used

5. Analyze change frequencies:
```
maat -l maat_evo.log -c git -a revisions
```
This way, we identify the parts of the code with most developer activity.

6. Counting lines with cloc (complexity):
http://cloc.sourceforge.net/
```
cloc ./ --by-file --csv --quiet
```

7. Merge complexity and effort:
```
maat -l maat_evo.log -c git -a revisions > maat_freqs.csv
cloc ./ --by-file --csv --quiet --report-file=maat_lines.csv
python scrips/merge_comp_freqs.py maat_freqs.csv maat_lines.csv
 ```