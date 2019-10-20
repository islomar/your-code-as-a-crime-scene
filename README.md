# Your code as a crime scene
Practice stuff from the book "Your code as a crime scene"

Author: Adam Tornhill, 2015
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
* Code visualization
  * https://wettel.github.io/codecity.html
  * https://github.com/aserg-ufmg/JSCity (CodeCity for JavaScript)
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
* We'll use indentation as a proxy for complexity (based by research)
* https://en.wikipedia.org/wiki/Brainfuck
* Manny Lehman: law of increasing complexity
* A high standard deviation points to many complex blocks of conditional logic
* The script **complexity_analysis.py** calculates logical indentation (4 spaces or one tab = 1 logical indentation)
```
prompt> python scripts/complexity_analysis.py hibernate-core/src/main/java/org/hibernate/cfg/Configuration.java
n,total,mean,sd,max
3335,8072,2.42,1.63,14
```
  * The total column is the accumulated complexity
  * A lot of indenting probably means nested conditions
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
* `temporal-coupling.sh`
* [Craft.net temporal coupling](https://docs.google.com/spreadsheets/d/1Sq5zy2q2YkUSsnaWdZ4_owdck6MFYVQurALtD0kx5a8/edit#gid=726429799)
* Analyze temporal coupling.
```
prompt> maat -l maat_evo.log -c git -a coupling
entity,coupled,degree,average-revs
```
* The degree specifies the percent of shared commits
* **average-revs**: weighted number of total revisions for the involved modules; we can filter out modules with too few revisions to avoid bias.
* Temporal coupling often indicates architectural decay.
* Lehman law: "Law of continuing change"
* Evolution radar:
  - A different approach to logical coupling
  - https://dl.acm.org/citation.cfm?id=1137992
* Use a storyboard to track evolution: e.g. for each iteration or n days/weeks.


## Build a safety net for your architecture
* Create `maat_src_test_boundaries.txt` with source vs test package locations. Copy this transformation file inside the root folder of the code to evaluate, and run `temporal-coupling-with-boundaries.sh`:
```
entity,coupled,degree,average-revs
Code,Test,80,65
```
* In 80% of the Code we modified, to touch Test as well.
* Create more detailed test boundaries:
```
entity,coupled,degree,average-revs
Code,End to end Test,42,50
Analysis Test,Code,42,49
Code,Parsers Test,41,49
```
* The end to end coupling might be too high, probably they should not depend so much on implementation details, take a look to it!
* Create a safety net for your automated tests, defining a change ratio:
`docker run -v $PWD:/data -it code-maat-app -l /data/maat_evo.log -c git -a revisions -g /data/maat_src_test_boundaries.txt`
  - you would get the number of revisions for Code and Tests
  - Takins several samples on several moments, you can track the trend and change ratio. If you change tests more than code, that's a very bad smell.


## Use beauty as a guiding principle
* Beauty is about consistency and avoiding surprises.
* Create `maat_pipes_filter_boundaries.txt` and run `docker run -v $PWD:/data -it code-maat-app -l /data/maat_evo.log -c git -a couplinh -g /data/maat_pipes_filter_boundaries.txt`
* Analyze layered architectures: `analyze_layered_architectures.sh`


## Norms, groups and false serial killers
* **Process loss** is the theory that groups, just as machines, cannot operate at 100 percent efficiency.
* **Pluralistic ignorance** happens in situations where everyone privately rejects a norm but thinks that everyone else in the group supports it.
* **Groupthink** is a disastrous consequence of social biases where the group ends up suppresising all forms of internal dissent.
* Generate a word cloud from the commits: `commits-word-cloud.sh`


## Discover organizational metrics in your codebase
* Diffusion of responsibility
* Hotspots attract multiple authors
* Studies suggest that quality decreases with the number of programmers.
* Organizational metrics outperform tradiional measures, such as code complexity or code coverage. One of these super-metrics was the number of programmers who worked on each component.
* All the examples here: `organizationa-metrics.sh`:
  * Discover the modules that are shared between multiple programmers
  * Calculate temporal coupling over a day
  * Identify main developers
  * Identify main developers by removed code
  * Calculate individual contributions
* We try to identify expensive communication paths.
  1. Identify parallel work.
  1. Compare against hotspots.
  1. Identify temporal coupling.
  1. Find the main developers.
  1. Check organiztional distance.
  1. Optimize for communciation!
* Rearrange the teams according to communication needs.


## Limitations
* Code Maat does not track name changes
* People moving between teams