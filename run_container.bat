@echo off
set "IMAGE_NAME=esoc_c_models"
set "WORKDIR=/usr/local/esoc_c_models"

docker build --build-arg WORKDIR=%WORKDIR% -t %IMAGE_NAME% .

if errorlevel 1 (
    echo Docker build failed. Exiting...
    exit /b 1
)

for /f "delims=" %%i in ('cd') do set "CURRENT_DIR=%%i"
set "CURRENT_DIR=%CURRENT_DIR:\=/%

docker run -it --rm --env WORKDIR=%WORKDIR% -v %CURRENT_DIR%:%WORKDIR%/data %IMAGE_NAME%
