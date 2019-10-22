docker run -v $PWD:/data -it code-maat-app -l /data/maat_evo.log -c git -a abs-churn
# Save the analysis results to a file and import the data into a spreadsheet application

## Link Code Churn to temporal coupling
docker run -v $PWD:/data -it code-maat-app -l /data/craft_evo_140808.log -c git -a entity-churn