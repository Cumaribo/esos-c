# ESOC Models Docker Container

This repository provides a Docker-based environment to run various ESOC models developed by SPRING and the Natural Capital Project.

## Prerequisites

- Ensure you have [Docker](https://www.docker.com/products/docker-desktop/) installed on your system.

---

## Input Data Mapping

When running a model, input data should be provided via a local directory. This directory is mapped to `/usr/local/esoc_c_models/local` in the container. For example, if your input data is in `./input_data` on your local machine, it will be accessible as `/usr/local/esoc_c_models/local/input_data` inside the container.

- **Input Directory**: Replace `./input_data` with the path to your local directory containing the input data. Ensure this directory exists and contains all required files.
- **Model Arguments**: Each model may require specific input arguments. Refer to the `.ini` file section below for more details on configuring model inputs.
- **Environment**: All models are run using the `hf39` Mamba Python environment preconfigured in the container. You can inspect how this environment is built by examining the `Dockerfile` in this repository.

---

## INI File Configuration

The models in this repository use `.ini` configuration files to specify input data paths, model parameters, and expected outputs. Below is a breakdown of the key sections and fields in these files.

### Example `.ini` File

```
[ca_ndr]
AOI_PATH=./watershed_ca.shp
AOI_SUBDIVISION_AREA_MIN_THRESHOLD=1
GLOBAL_WORKSPACE_DIR=./ca_ndr_workspace

[projection]
PROJECTION_SOURCE={{AOI_PATH}}
SUBDIVISION_BLOCK_SIZE=14947307618.227
TARGET_PIXEL_SIZE=30.0

[non_spatial_input]
RESULTS_SUFFIX=
THRESHOLD_FLOW_ACCUMULATION=1000
K_PARAM=2
SINGLE_OUTLET={{multi_aoi_in_batch}}
BIOPHYSICAL_TABLE_PATH=./LULC_BT_NDR.csv
BIOPHYISICAL_LUCODE_FIELDNAME=lucode
WORKSPACE_DIR={{shard_working_dir}}
WATERSHEDS_PATH={{shard_aoi_path}}
MAX_PIXEL_FILL_COUNT=0

[spatial_input]
DEM_PATH=./dem_ca_bu_compressed.tif
LULC_PATH=./landcover_ca_compressed.tif
RUNOFF_PROXY_PATH=./runoff_proxy_ca_compressed.tif
FERTILIZER_PATH=./N_load_ca_compressed.tif

[function]
MODULE=inspring.ndr_mfd_plus
FUNCTION_NAME=execute

[expected_output]
TARGET_PROJECTION_AND_BB_SOURCE={{AOI_PATH}}
TARGET_PIXEL_SIZE=30
N_EXPORT={{GLOBAL_WORKSPACE_DIR}}/global_n_export.tif,{{shard_working_dir}}/n_export.tif,-9999
N_RETENTION={{GLOBAL_WORKSPACE_DIR}}/global_n_retention.tif,{{shard_working_dir}}/n_retention.tif,-9999
```

### Sections and Fields

#### `[ca_ndr]`
- Note the `ca_ndr` is the prefix of the `.ini` file and should be named accordingly.
- **AOI_PATH**: Path to the shapefile defining the area of interest (AOI). Relative to the `.ini` file.
- **AOI_SUBDIVISION_AREA_MIN_THRESHOLD**: Minimum area threshold for subdividing the AOI.
- **GLOBAL_WORKSPACE_DIR**: Directory for storing global output files.

#### `[projection]`
- **PROJECTION_SOURCE**: Source for the spatial projection, typically referencing the AOI.
- **SUBDIVISION_BLOCK_SIZE**: Spatial subdivision block size (e.g., in square meters).
- **TARGET_PIXEL_SIZE**: Pixel resolution for raster processing (e.g., 30 meters).

#### `[non_spatial_input]`
- **RESULTS_SUFFIX**: Optional suffix for naming result files.
- **THRESHOLD_FLOW_ACCUMULATION**: Threshold for flow accumulation in the model.
- **K_PARAM**: Model-specific parameter (e.g., runoff coefficient).
- **BIOPHYSICAL_TABLE_PATH**: Path to the CSV containing biophysical data (e.g., land cover and nutrient retention).
- **BIOPHYISICAL_LUCODE_FIELDNAME**: Field name in the biophysical table specifying land cover codes.
- **WORKSPACE_DIR**: Directory for temporary or shard-specific outputs.
- **WATERSHEDS_PATH**: Path to watershed shapefiles.
- **MAX_PIXEL_FILL_COUNT**: Maximum pixel fill count for DEM pre-filling.

#### `[spatial_input]`
- **DEM_PATH**: Path to the Digital Elevation Model (DEM).
- **LULC_PATH**: Path to the land use/land cover raster.
- **RUNOFF_PROXY_PATH**: Path to the runoff proxy raster.
- **FERTILIZER_PATH**: Path to the fertilizer loading raster.

#### `[function]`
- **MODULE**: Python module to execute the model.
- **FUNCTION_NAME**: Specific function to call within the module.

#### `[expected_output]`
- **TARGET_PROJECTION_AND_BB_SOURCE**: Reference for output projection and bounding box.
- **TARGET_PIXEL_SIZE**: Pixel resolution of the output raster.
- **N_EXPORT**: Paths for nitrogen export outputs (global and shard-level).
- **N_RETENTION**: Paths for nitrogen retention outputs (global and shard-level).

---

### Notes on `.ini` Files

- **Relative Paths**: Paths in the `.ini` file are relative to the file's location unless specified as absolute.
- **Dynamic References**: Placeholders like `{{AOI_PATH}}` dynamically reference other fields in the `.ini` file.
- **Expected Files**: Ensure all referenced files exist before running the model.

---

## Usage

To run a model, launch the container with the following command:

```run_container.bat```

Then, inside the container, execute a model using its .ini configuration file:

```python -m ecoshard.geosharding.geosharding ./local/data/ndr/ca_ndr.ini```

Note: The first time you run `run_container.bat`, Docker will pull the container locally. This may take some time, but subsequent runs will reuse the existing container.

## Additional Resources
Dockerfile: Review the Dockerfile in this repository to see how the container environment is built.
