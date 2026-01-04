# Code forensics

https://dev.to/antoinega/analyze-your-git-5ej0

1. Create a `gulpfile.js` in the root repository path
1. `npm install code-forensics`
1. `npm install gulp@4`
1. `docker run -v $PWD:/data -w /data -p 3000:3000 -it jdevoo/code-forensic developer-effort-analysis`
1. `docker run -v $PWD:/data -w /data -p 3000:3000 -it jdevoo/code-forensic webserver`



docker run -it --rm -v $PWD:/root/shared -w /root/shared -p 3000:3000 -e COMMAND_DEBUG=true jdevoo/code-forensic developer-effort-analysis



https://github.com/smontanari/code-forensics/wiki/Tasks-parameters#datetime-interval-of-analysis