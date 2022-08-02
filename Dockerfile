# 1 IMAGE
FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

# 2 GENERAL TOOLS
RUN apt-get update -y && \
    apt-get install apt-utils -y && \
    apt-get install git curl build-essential -y && \
    apt install software-properties-common -y && \
    apt-get install time

# 3 GDAL & SQLite 
# Info: GDAL 3.0.4 & sqlite3 --version 3.31.1
RUN add-apt-repository ppa:ubuntugis/ppa -y && \
    apt-get update -y && \
    apt-get install libpq-dev gdal-bin libgdal-dev -y && \
    apt-get install sqlite3


# 4 PYTHON 3.8
RUN add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update -y && \
    apt-get install python3.8 python3-distutils python3-pip python3-apt python3.8-dev -y && \
    python3.8 -m pip install pipenv

# 5 RUNNER BASH SCRIPTS
COPY ./pipeline_runner /src/pipeline_runner

# 6 & 7 SHARING AREA BETWEEN HOST AND DOCKER
WORKDIR /src
RUN mkdir sharing_area

# 8 DIGITAL LAND PYTHON PACKAGE
RUN git clone https://github.com/digital-land/digital-land-python.git

# 9 & 10 PIPENV ENVIRONMENTS
WORKDIR /src/pipeline_runner
RUN python3.8 -m pipenv install && \
    export PATH="~/.local/bin:$PATH"

# 11 DIGITAL-LAND-PYTHON INIT INSIDE VIRTUAL ENV
RUN pipenv run bash 02-prepare-dependencies.sh
