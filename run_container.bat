@echo on

:: Set the Docker image name and work directory
set "IMAGE_NAME=therealspring/esos-spring-env:latest"
set "WORKDIR=/usr/local/esoc_c_models"
set "CURRENT_DIR=%CD%"

:: Build the Docker image
docker pull %IMAGE_NAME% .

:: Ensure at least one argument is provided
if "%1"=="" (
    echo "No python script was passed, so running shell directly"
    call docker run -it --rm --env WORKDIR=%WORKDIR% -v C:\Users\richp\repositories\ndr_sdr_global:%WORKDIR%/ndr_sdr_global -v "%CURRENT_DIR%:%WORKDIR%/local" %IMAGE_NAME% /bin/bash
    exit /b 1
)

:: Get the script path (first argument)
set "SCRIPT_PATH=%1"

:: Shift the arguments to pass the rest to Docker
shift
set "SCRIPT_ARGS=%*"

:: Map the current directory to the container's work directory and run the Python script with all additional arguments
docker run -it --rm --env WORKDIR=%WORKDIR% -v "%CURRENT_DIR%:%WORKDIR%/data" %IMAGE_NAME% micromamba run -n hf39 python %SCRIPT_PATH% %SCRIPT_ARGS%
