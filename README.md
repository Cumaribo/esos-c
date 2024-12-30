# ESOC Models Docker Container

This repository provides a Docker-based environment to run various ESOC models developed by SPRING and the Natural Capital Project.

---

## Cloned Repositories and Models

The following models are included in the container:

1. **SWY Global**
   Path: `/usr/local/esoc_c_models/swy_global`

2. **NDR & SDR Global**
   Path: `/usr/local/esoc_c_models/ndr_sdr_global`


3. **Downstream Beneficiaries**
   Path: `/usr/local/esoc_c_models/downstream-beneficiaries`


4. **Coastal Risk Reduction**
   Path: `/usr/local/esoc_c_models/coastal_risk_reduction`


5. **People Protected by Coastal Habitat**
   Path: `/usr/local/esoc_c_models/people_protected_by_coastal_habitat`


6. **Distance to Habitat with Friction**
   Path: `/usr/local/esoc_c_models/distance-to-hab-with-friction`
   layers.

7. **Pollination Sufficiency**
   Path: `/usr/local/esoc_c_models/pollination_sufficiency`


---

## Prerequisites

- Ensure you have **Docker** installed on your system.

---

## Input Data Mapping

When running a model, input data should be provided via a local directory. This directory is mapped to `/usr/local/esoc_c_models/data` in the container. For example, if your input data is in `./input_data` on your local machine, it will be accessible as `/usr/local/esoc_c_models/data/input_data` inside the container.

* Input Directory: Replace ./input_data with the path to your local directory containing the input data. Ensure this directory exists and contains all required files.
* Model Arguments: Each model may require specific input arguments. Refer to the documentation of the respective model for more details.
* Environment: All models run using the hf39 Mamba Python environment preconfigured in the container, you can inspect how this environment is built by examining the `Dockerfile` in this repository.

---

## Usage

To run a model, provide the script path and any required input arguments. Example:

`./run_container.bat /usr/local/esoc_c_models/swy_global/run_swy_global.py --help`

Will show you the command line arguments to run the `run_swy_global.py` script.
