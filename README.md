# Your code as a crime scene
Practice stuff from the book "Your code as a crime scene"

Author: Adam Tornhill
https://pragprog.com/book/atcrime/code-as-acrime-scene


## Interesting links
* [Book forum](https://forums.pragprog.com/forums/367)
* Adam Tornhill
  - https://codescene.io/ (Tools as a Service)
  - [GOTO 2016: Talk from Adam Tornhill](https://www.youtube.com/watch?v=7FApEq8wum4)
  - http://adamtornhill.com/articles/aspnetclones/killtheclones.html
  - http://adamtornhill.com/articles/socialside/socialsideofcode.htm
* [BilboStack 2016: Talk from Vicenç García-Altés](https://vimeo.com/154470784)
* https://www.infoq.com/news/2015/03/code-as-a-crime-scene


## Tools
* https://github.com/smontanari/code-forensics
* http://www.adamtornhill.com/code/crimescenetools.htm
  * Executable Code Maat
  * Python scripts
  * Sample files
* https://github.com/adamtornhill/code-maat
* https://wettel.github.io/codecity.html
* Evolution of Code Maat: https://codescene.io/projects
  - [Applied to payments-api](https://codescene.io/projects/2962/jobs/16077/results)


## Notes
* The number of lines of code is not the best metric for complexity... but the others are not much better (at this that one is simple and language-agnostic). Cyclomatic complexity does not have the whole context.
* The number of commits depends on the style of each developer (baby steps or not).
* Code doesn't lie (vs "Everybody lies" from House)
* Temporal coupling: measure of evolution of code. The other metrics are static, here we introduce another dimension: TIME.
  - Temporal coupling is a great to detect clones, copy-paste.
* Dependencies between code = dependencies between people. Conway's law.
  - Social networks in code
* Align you Architecture and your Organization.
* Fractal figures. Too many developers touching a piece: too many responsibilities. Identify main developers in a component/file. Look who has done most contributions.
* The more developers, the less quality.
* "We need to understand both how the system came to be and how the people working on it interact with each other"
* Blending of forensic pyschology and software evolution.
* Software develoment is a learning activity.
* We read more code than we write. Understanding the existing product is the dominant maintenance activity. Our primary task as programmers isn't to write code, but to understand it.
* Identify abandoned subsystems: parts of code mostly written by people who are not in the organization anymore.
* It's important to verify your intuitive ideas with supporting data.
* Hotspots make good predictors of defects. Defects tend to cluster in a few problematic modules.
* Choose a timespan for your analyses, not the project's total lifetime: it might obscure important recent trends and flag hotspots that no longer exist.
  * Between releases
  * Over iterations
  * Around significant events: e.g. teams reorganization.
* Design to isolate change
* Stabilize by extracting cohesive design elements
* When to analyze it:
  * Between releases
  * Over iterations
  * Around significant events
* Hotspots typically accont for around 4 to 6 percent of the total codebase.
* Judge Hotspots with the Power of Names


## Ideas to do
* Identify most contributors (people and team) for a specific repository, component, file.

## Creating an offender profile
* `scripts/create-offender-profile.sh`
* `scripts/install-code-maat.sh`
* `scripts/run-code-maat.sh`

## Analyze Hotspots in Large-Scale Systems
* `analyze-hibernate.sh`
* Launch the Hotspot visualizations
  * The D3.js visualizations used are based on the [>oomable Circle Packing algorithm](https://observablehq.com/@d3/zoomable-circle-packing)
  * A circle represents a module
  * Circle packing: the more complex a module (number of lines), the larger the circle
  * The more effort spent on a module (number of revisions), the more intense its color
  * A cluster shows how changes to one hotspot are intimately tied to changes in other areas.
  * Multipple hotspots that change together are signs of unstanble code.
* There is a trong correlation between the stability of the code and its quality: stabilize by extracting cohesive design elements.
  - The more of your code you can protect from changes, the better.
* Visualize the data!!!
```
prompt> python csv_as_enclosure_json.py -h
prompt> python csv_as_enclosure_json.py --structure hib_lines.csv --weights hib_freqs.csv > hib_hotspot.json
```
Update the hibzoomable.html to reference that JSON file


## Judge Hotspots with the Powe of Names
Heuristincs to pass quick judgments on your hotspots: Naming

## Calculate Complexity trends from your code's shape
* We'll use indentation as a proxy for complexity
* https://en.wikipedia.org/wiki/Brainfuck
* Manny Lehman: law of increasing complexity
* The script **complexity_analysis.py** calculates logical indentation
```
prompt> python scripts/complexity_analysis.py hibernate-core/src/main/java/org/hibernate/cfg/Configuration.java
n,total,mean,sd,max
3335,8072,2.42,1.63,14
```
  * The total column is the accumulated complexity
* Focus on a range of revisions
```
python scripts/git_complexity_trend.py --start ccc087b --end 46c962e --file hibernate-core/src/main/java/org/hibernate/cfg/Configuration.java
```
* [Total complexity trend graph](https://docs.google.com/spreadsheets/d/1AgK6iz9_wkOuILe6iEJ6ajj6ouMNHx5mIoRShV-jq90/edit#gid=339668373)


## Treat your code as code as cooperative witness
* **Temporal coupling**: when you often commit some modules/classes at the same time.
  * Changes to one of them means changes in the other. They're entagled.
* A false memory sounds like a paradox.
* Our human memory is a constructive process.
* Temporal coupling == Change coupling == Logical coupling
* Intentional coupling (explicit dependency) vs Incidental coupling (temporal only)
* Reasons behind the temporal coupling:
  * Copy-paste
  * Inadequate encapsulation
  * Producer-consumer


## Detect Architectural Decay
SOC: Sum Of coupling
```
prompt> maat -l maat_evo.log -c git -a soc
entity,soc
src/code_maat/app/app.clj,105
test/code_maat/end_to_end/scenario_tests.clj,97
src/code_maat/core.clj,93
```
app.clj changes the most with other modules

Analyze temporal coupling.
```
prompt> maat -l maat_evo.log -c git -a coupling
entity,coupled,degree,average-revs
src/code_maat/parsers/git.clj,test/code_maat/parsers/git_test.clj,83,12
src/code_maat/analysis/entities.clj,test/code_maat/analysis/entities_test.clj,76,7
src/code_maat/analysis/authors.clj,test/code_maat/analysis/authors_test.clj,72,11
src/code_maat/analysis/logical_coupling.clj,test/code_maat/analysis/logical_coupling_test.clj,66,20
test/code_maat/analysis/authors_test.clj,test/code_maat/analysis/test_data.clj,66,8
src/code_maat/app/app.clj,src/code_maat/core.clj,60,23
src/code_maat/app/app.clj,test/code_maat/end_to_end/scenario_tests.clj,57,23
```
* The degree specifies the percent of shared commits
* **average-revs**: weighted number of total revisions for the involved modules; we can filter out modules with too few revisions to avoid bias.
* Temporal coupling often indicates architectural decay.
* Lehman law: "Law of continuing change"
* Identify architecurally significant modules:
```
prompt> git clone https://github.com/SirCmpwn/Craft.Net.git
prompt> git log --pretty=format:'[%h] %an %ad %s' --date=short --numstat --before=2014-08-08 > craft_evo_complete.log
prompt> maat -l craft_evo_complete.log -c git -a soc
entity,soc
Craft.Net.Server/Craft.Net.Server.csproj,685
Craft.Net.Server/MinecraftServer.cs,635
Craft.Net.Data/Craft.Net.Data.csproj,521
Craft.Net.Server/MinecraftClient.cs,464


prompt> git log --pretty=format:'[%h] %an %ad %s' --date=short --numstat --before=2013-01-01 > craft_evo_130101.log
prompt> maat -l craft_evo_130101.log -c git -a coupling > craft_coupling_130101.csv

prompt> git log --pretty=format:'[%h] %an %ad %s' --date=short --numstat --after=2013-01-01 --before=2014-08-08> craft_evo_140808.log
prompt> maat -l craft_evo_130101.log -c git -a coupling > craft_evo_140808.csv
```

## Limitations
* Code Maat does not track name changes
* People moving between teams