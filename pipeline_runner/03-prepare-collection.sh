# Collection we will work with
COLLECTION_REPO_NAME='listed-building-collection'

# Clean state
rm -rf hoisted dataset issue var collection transformed

# Get endpoint and source csvs
mkdir -p collection
curl -qfsL 'https://raw.githubusercontent.com/digital-land/'$COLLECTION_REPO_NAME'/main/collection/endpoint.csv' > collection/endpoint.csv
curl -qfsL 'https://raw.githubusercontent.com/digital-land/'$COLLECTION_REPO_NAME'/main/collection/source.csv' > collection/source.csv

# Get pipeline config csvs
mkdir -p pipeline
curl -qfsL 'https://raw.githubusercontent.com/digital-land/'$COLLECTION_REPO_NAME'/main/pipeline/column.csv' > pipeline/column.csv
curl -qfsL 'https://raw.githubusercontent.com/digital-land/'$COLLECTION_REPO_NAME'/main/pipeline/concat.csv' > pipeline/concat.csv
curl -qfsL 'https://raw.githubusercontent.com/digital-land/'$COLLECTION_REPO_NAME'/main/pipeline/convert.csv' > pipeline/convert.csv
curl -qfsL 'https://raw.githubusercontent.com/digital-land/'$COLLECTION_REPO_NAME'/main/pipeline/default.csv' > pipeline/default.csv
curl -qfsL 'https://raw.githubusercontent.com/digital-land/'$COLLECTION_REPO_NAME'/main/pipeline/lookup.csv' > pipeline/lookup.csv
curl -qfsL 'https://raw.githubusercontent.com/digital-land/'$COLLECTION_REPO_NAME'/main/pipeline/old-entity.csv' > pipeline/old-entity.csv
curl -qfsL 'https://raw.githubusercontent.com/digital-land/'$COLLECTION_REPO_NAME'/main/pipeline/patch.csv' > pipeline/patch.csv
curl -qfsL 'https://raw.githubusercontent.com/digital-land/'$COLLECTION_REPO_NAME'/main/pipeline/pipeline-callback.py' > pipeline/pipeline-callback.py
curl -qfsL 'https://raw.githubusercontent.com/digital-land/'$COLLECTION_REPO_NAME'/main/pipeline/skip.csv' > pipeline/skip.csv
curl -qfsL 'https://raw.githubusercontent.com/digital-land/'$COLLECTION_REPO_NAME'/main/pipeline/' > pipeline/transform.csv

# Ger orgnaisations csv
mkdir -p var/cache
curl -qfsL 'https://raw.githubusercontent.com/digital-land/organisation-dataset/main/collection/organisation.csv' > var/cache/organisation.csv

# Copy specification folder from the digital-land-python folder to the pipeline runner folder
cp -a /src/digital-land-python/specification/. /src/pipeline_runner/specification/


echo '-------- Piperunner preparation step completed for '$COLLECTION_REPO_NAME
