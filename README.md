# DOCKER PIPELINE RUNNER

## IMAGE CREATION STEPS (JUST NEEDED ONCE)

 It is not the scope of the present repo to detail the installation of docker itself (or docker desktop) in all different environments, for this reason this instructions assume you have docker installed in your local computer. The steps you see in the SETUP session are the ones you need to run just once so that you prepare a docker image that will be used to run the pipelines.

 1 First clone the docker runner repo and change directories to get inside it

    git clone https://github.com/digital-land/digital-land-docker-pipeline-runner.git
    cd digital-land-docker-pipeline-runner

 2 If you use VS studio code we suggest opening the folder you just created by cloning as your workspace and then open a new terminal and run:
 
    docker build -t pipe_runner_img .

 3 Start a installation container (to be able to mirror an internal folder into host)

    docker run -it --name pr_installation_container pipe_runner_img

 4 Your terminal will now be inside the container, keep that terminal running and open one more terminal window so that the second one is not inside the container.

 5 On the terminal that is not inside the container make sure you are inside the dir 'digital-land-docker-pipeline-runner' that was created when you cloned the repo. Now, we need to copy 2 folders from inside the container to your local for transparancy, so we can see them inside the docker when we run cod inside it:

    docker cp pr_installation_container:/src/digital-land-python/. `pwd`/digital-land-python
    docker cp pr_installation_container:/root/.local/share/virtualenvs/. `pwd`/virtual_envs

6 Go back to first terminal and exit to bring down the installation container:
    
    exit

7 You can delete installation container as you won't need it anymore

    docker container rm pr_installation_container
-----

## USING THE PIPELINE RUNNER TO RUN ONE RESOURCE
 This steps you use anytime you want to run the pipeline locally. If you want to run collections with latest version of the digital-land-python package you need to re-run the installation steps

1 To create a new pipeline runner container from the image run:

    docker run -it --name pipeline_runner_cont -p 8001:8001 -v `pwd`/pipeline_runner:/src/pipeline_runner  -v `pwd`/digital-land-python:/src/digital-land-python -v `pwd`/sharing_area:/src/sharing_area -v `pwd`/virtual_envs:/root/.local/share/virtualenvs/ pipe_runner_img

2 To start an existing container in interactive mode run:

    docker start -ai pipeline_runner_cont
 
3 Inside docker runner you need to activate the virtual env:

    cd /src/pipeline_runner
    pipenv shell

4 Open the file '03-prepare-collection.sh' and set the variable **COLLECTION_REPO_NAME** to the collection you want to test/work with.

5 To prepare folders and files for a collection:
    
        bash 03-prepare-collection.sh
    (Note: this step downloads the endpoint.csv and source.csv from the collection repository you can change them after this step to run any tests but remember that if you re-run this step they will be retrieved again and reflect again the originals in the repository)

6 You can now make any editions/changes you want to test in the files: 
    
        collection/endpoint.csv
        collection/source.csv
        var/cache/organisation.csv
        pipeline/*.csv
    (For example, you might want to keep only 1 specific endpoint and the respective source of that endpoint):

7 To collect the resources run:

        bash 04-collect-resources.sh
    (Note: this step is able to collect several resources at once and they all will be saved at collection/resource and the logs of the collection will be saved at collection/log/)
    
    If you need to rerun the collection more than once on a day, you will need to erase the entry for today in the collection/log/ directory.

    For example, to rerun on 2022-07-26:
    
        rm collection/log/2022-07-26/*

8 This step allow you to proccess only one resource at a time. To do so you will need to fill in a few variables inside the file '05-run-pipeline-transformations.sh'. If you need to process more than one resource you will need to repeat this step each time with the appropriate variables:
    
        DATASET: this is usually the column 'collection' of the 'collection/source.csv' file
        ENDPOINT: this is the has value in the column 'endpoint' of the 'collection/source.csv' file
        ORGANISATION: this is the has value in the column 'organisation' of the 'collection/source.csv' file
        ENTRYDATE: for testing purposes any date in the format 'YYYY-MM-DD' can be used 
        RESOURCE: this is the name (also a hash) of the file collected in the folder 'collection/resource/'.
    
    (Note: to get the resource name-hash it is easier if you right click on the file and select 'Copy path' and than get rid of the folder, keeping only the hash)

        For example, from:
            /home/henrique_farina/collection/resource/6c961fcd2c76a1602a98f309dc7bffe4323b3192bb839c9c773b4365f9a2ec41
    
        You would fill in:    
            RESOURCE='6c961fcd2c76a1602a98f309dc7bffe4323b3192bb839c9c773b4365f9a2ec41'
    

9 Once you filled in the variables mentioned, you can run the pipeline for the resource with:

        bash 05-run-pipeline-transformations.sh

<p>&nbsp;</p>    

**Now you should be able to:**
   
### a. See any errors in your terminal as the pipeline runs
    
### b. Check any intermediate files and logs using the cloud shell file explorer, these folders should be of your interest:
            collection/resource
            collection/log
            transformed/
            issue/
            my_temp_dir/
            dataset/
            hoiseted/

**SOME IMPORTANT NOTES**

**NOTE 1:** Finishing session and stopping the docker container

    To finish your session and stop the docker container we advise the following:
         a) clean the container of the files that were generated for the present collection:

             bash 06-clean-collection.sh

         b) leave the virtual environment:
         
             exit

         c) leave the docker container:

             exit


**NOTE 2**: 

    After it finishes you should have all files generated during execution in the following folders of /pipeline_runner:

     collection
     dataset
     hoisted
     issue
     my_temp_dir
     pipeline
     specification
     transformed
     var

**NOTE 3**: cleaning your runner so you can start a new collection run:
    
    bash 06-clean-collection.sh        
    
    and start again from 'USING THE PIPELINE RUNNER TO RUN ONE RESOURCE' - step1 

**NOTE 4**: To open a sqlite file with a datasette host inside the docker:
    
    Run this inside the container:

    datasette  -h 0.0.0.0 dataset/YOUR-DATASET-NAME-HERE.sqlite3
    
    (for example: datasette  -h 0.0.0.0 dataset/area-of-outstanding-natural-beauty.sqlite3)

    And open http://localhost:8001/ on the host browser

------

# USING THE PIPELINE RUNNER DOCKER TO CLONE AND RUN AN ENTIRE COLLECTION:

If you need to create a new pipeline runner container from the image run:

    docker run -it --name pipeline_runner_cont -p 8001:8001 -v `pwd`/pipeline_runner:/src/pipeline_runner  -v `pwd`/digital-land-python:/src/digital-land-python -v `pwd`/sharing_area:/src/sharing_area -v `pwd`/virtual_envs:/root/.local/share/virtualenvs/ pipe_runner_img

To start an existing container in interactive mode run (use the same name as when created):

    docker start -ai pipeline_runner_cont

To run clonned packages you need to change the temp directory used to unzip files, on your local machine:

    Open the file:
    /virtual_envs/pipeline_runner-Aa5TfYuL/src/digital-land/digital_land/cli.py

    Just before the definition of the function *pipeline_cmd_API*, change the custom_temp_dir default from None to "my_temp_dir"


Inside docker runner you need to activate the virtual env:
    
    cd /src/pipeline_runner
    pipenv shell

Now if you are going to clone a collection repo you will want it to be cloned inside the sharing_area so you can see all files:

    cd ../sharing_area/

Clone the repo (using area of outstanding natural beauty as example):

    git clone https://github.com/digital-land/area-of-outstanding-natural-beauty-collection.git

Change directory to the one you just cloned

    cd area-of-outstanding-natural-beauty-collection
    (the dir name will be the same as the name of the repo cloned)

Prepare for execution

    mkdir my_temp_dir
    make makerules
    make init 

Run the collection and execution

    make collect
    make collection
    make transformed
    make dataset

# USING THE DOCKER PIPELINE RUNNER TO WRITE AND RUN EXPECTATIONS:

First follow the image creation steps.

If you are creating a new container use:

    docker run -it --name new_pipeline_runner_cont -p 8001:8001 -v `pwd`/pipeline_runner:/src/pipeline_runner  -v `pwd`/digital-land-python:/src/digital-land-python -v `pwd`/sharing_area:/src/sharing_area -v `pwd`/virtual_envs:/root/.local/share/virtualenvs/ new_pipe_runner_img

If you already have a container created and just want to re-start it, use:

    docker start -ai new_pipeline_runner_cont

Once your terminal is inside the container, make sure you are inside the virtual env of the pipeline runner, with:

    cd /src/pipeline_runner
    pipenv shell

Still in the pipeline_runner folder, run the pipeline runner preparation bash to create some folders that the digital-land-python package expect to exist (don't worry about the collection name, any collection will do as this step is more to have the usual folder structure that the package expects):

    cd /src/pipeline_runner
    bash 03-prepare-collection.sh

We suggest now creating a folder to store the datasets you want to run expectations against, a folder for your expectation yamls files and a folder for the results of expectations, in the sharing area:

    cd /src/sharing_area/
    mkdir datasets expectation_yamls expectation_results

Now you can place the datasets in /src/sharing_area/datasets/ and write your yaml file and save in /src/sharing_area/expectation_yamls and run them using:

    cd /src/pipeline_runner
    digital-land expectations --results-path "src/sharing_area/expectations_results" --sqlite-dataset-path "/src/sharing_area/datasets/YOUR_DATASET.sqlite3" --data-quality-yaml "/src/sharing_area/expectation_yamls/YOUR_EXPECTATION_YAML.yaml"

The results will be saved as jsons in "src/sharing_area/expectations_results", it you are writting yamls for several datasets we suggest creating a results folder for each dataset and use --results-path accodingly so that you can easily identify results of data quality for each dataset.

Note 1: the command above runs from the pipeline_runner folder (to use the standard folders that the package requires)

Note 2: we suggest the folders mentioned but you can use any folders you wish as long as you provide them in the arguments --results_path , --sqlite-dataset-path , -- data-quality-yaml
