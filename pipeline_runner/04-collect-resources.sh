#  Collect:
digital-land collect collection/endpoint.csv
echo '-------- Collection step completed'

#  Save csv
digital-land collection-save-csv
digital-land collection-pipeline-makerules > collection/pipeline.mk
echo '-------- CSV save step completed'
