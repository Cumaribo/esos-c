@echo on

:: Set the Docker image name and work directory
set "IMAGE_NAME=esoc_c_models"
set "WORKDIR=/usr/local/esoc_c_models"

:: Ensure at least one argument is provided
if "%1"=="" (
    echo "Error: Please provide the Python script to run as the first argument."
    exit /b 1
)

:: Get the script path (first argument)
set "SCRIPT_PATH=%1"

:: Shift the arguments to pass the rest to Docker
shift
set "SCRIPT_ARGS=%*"

:: Build the Docker image
docker build -t %IMAGE_NAME% .

:: Map the current directory to the container's work directory and run the Python script with all additional arguments
set "CURRENT_DIR=%CD%"
docker run -it --rm --env WORKDIR=%WORKDIR% -v "%CURRENT_DIR%:%WORKDIR%/data" %IMAGE_NAME% micromamba run -n hf39 python %SCRIPT_PATH% %SCRIPT_ARGS%
