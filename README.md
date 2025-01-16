# ESOC Models Docker Container

This repository provides a Docker-based environment to run various ESOC models developed by SPRING and the Natural Capital Project.

## Prerequisites

- Ensure you have [Docker](https://www.docker.com/products/docker-desktop/) installed on your system.

---

## Input Data Mapping

When running a model, input data should be provided via a local directory. This directory is mapped to `/usr/local/esoc_c_models/local` in the container. For example, if your input data is in `./input_data` on your local machine, it will be accessible as `/usr/local/esoc_c_models/local/input_data` inside the container.

* Input Directory: Replace ./input_data with the path to your local directory containing the input data. Ensure this directory exists and contains all required files.
* Model Arguments: Each model may require specific input arguments. Refer to the documentation of the respective model for more details.
* Environment: All models are run using the `hf39` Mamba Python environment preconfigured in the container, you can inspect how this environment is built by examining the `Dockerfile` in this repository.

---

## Usage

To run a model, launch the container with the following command :

`run_container.bat`

Then inside the container you can run commands such as:

`python -m ecoshard.geosharding.geosharding ./local/data/ndr/ca_ndr.ini`


Note the first time you run `run_container.bat` Docker will pull the container locally. This may take some time, but futher runs will reuse the existing container.
